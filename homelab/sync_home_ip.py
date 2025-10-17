#!/usr/bin/env python3
"""
Script to check public IP and send it to Telegram
"""

import logging
import os
import sys
import requests
import pendulum
from dotenv import load_dotenv
from pathlib import Path

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(name)s - %(levelname)s - %(message)s",
    handlers=[logging.StreamHandler(), logging.FileHandler("sync_home_ip.log")],
)
logger = logging.getLogger(__name__)

load_dotenv()

SCRIPT_DIR = Path(__file__).parent
IP_FILE = SCRIPT_DIR / "last_ip.txt"

API_PROVIDERS = (
    "https://icanhazip.com",
    "https://api.ipify.org",
    "https://ifconfig.me/ip",
)


def get_public_ip():
    """Fetch public IP address from multiple providers with fallback"""

    for provider in API_PROVIDERS:
        try:
            response = requests.get(provider, timeout=5)
            if response.status_code == 200:
                return response.text.strip()
        except Exception as e:
            logger.debug(f"Failed to get IP from {provider}: {e}")
            continue

    logger.error("Failed to retrieve IP from all providers")
    return None


def read_last_ip():
    """Read the last known IP from file"""
    try:
        if IP_FILE.exists():
            return IP_FILE.read_text().strip()
    except Exception as e:
        logger.error(f"Error reading last IP: {e}")
    return None


def save_ip(ip):
    """Save current IP to file"""
    try:
        IP_FILE.write_text(ip)
        logger.debug(f"Saved IP to {IP_FILE}")
    except Exception as e:
        logger.error(f"Error saving IP: {e}")


def send_telegram_message(token, chat_id, message):
    """Send message to Telegram"""
    url = f"https://api.telegram.org/bot{token}/sendMessage"

    payload = {"chat_id": chat_id, "text": message, "parse_mode": "HTML"}

    try:
        response = requests.post(url, json=payload, timeout=10)
        response.raise_for_status()
        logger.debug(f"Successfully sent Telegram message: {message}")
        return True
    except Exception as e:
        logger.error(f"Failed to send Telegram message: {e}")
        return False


def send_ip_message(bot_token, chat_id, ip_address):
    """Format and send IP notification to Telegram"""
    try:
        # Get hostname
        hostname = os.uname().nodename

        # Prepare message
        timestamp = pendulum.now()
        message = f"🖥️ <b>{hostname}</b> is online\n\n"
        message += f"🌐 Public IP: <code>{ip_address}</code>\n"
        message += f"🕐 Time: {timestamp.to_datetime_string()}"

        # Send to Telegram
        if send_telegram_message(bot_token, chat_id, message):
            logger.info(f"Successfully sent IP {ip_address} to Telegram")
            return True
        else:
            logger.error(f"Failed to send IP {ip_address} to Telegram")
            return False
    except Exception as e:
        logger.error(f"Error in send_ip_message: {e}")
        return False


def main():
    # Get configuration from environment variables
    bot_token = os.getenv("TELEGRAM_BOT_TOKEN")
    chat_id = os.getenv("TELEGRAM_CHAT_ID")

    if not bot_token:
        logger.error("TELEGRAM_BOT_TOKEN environment variable not set")
        sys.exit(1)

    if not chat_id:
        logger.error("TELEGRAM_CHAT_ID environment variable not set")
        sys.exit(1)

    try:
        # Get public IP
        current_ip = get_public_ip()
        logger.debug(f"Current public IP: {current_ip}")

        if not current_ip:
            logger.error("Failed to retrieve IP from all providers")
            sys.exit(1)

        last_ip = read_last_ip()
        logger.debug(f"Last known IP: {last_ip if last_ip else 'None'}")

        # Check if IP has changed
        if last_ip and (current_ip == last_ip):
            logger.debug("IP has not changed. No message sent.")
            sys.exit(0)

        # IP has changed, send notification
        logger.info(
            f"IP has changed from {last_ip} to {current_ip}. Sending notification..."
        )

        # Send notification
        if not send_ip_message(bot_token, chat_id, current_ip):
            sys.exit(1)

        # Save current IP
        save_ip(current_ip)

    except Exception as e:
        logger.critical(f"Unexpected error: {e}", exc_info=True)
        sys.exit(1)


if __name__ == "__main__":
    main()
