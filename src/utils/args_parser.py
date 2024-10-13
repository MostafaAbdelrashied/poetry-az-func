import argparse


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Markdown modelling pipeline")

    parser.add_argument(
        "--samples",
        type=str,
        nargs="+",
        help="List of sample models to process",
        required=False,
        default=None,
    )

    parser.add_argument(
        "--log-level",
        type=str,
        choices=["TRACE", "DEBUG", "INFO", "SUCCESS", "WARNING", "ERROR", "CRITICAL"],
        default="DEBUG",
        help="Set the logging level",
    )

    args, _ = parser.parse_known_args()

    return args
