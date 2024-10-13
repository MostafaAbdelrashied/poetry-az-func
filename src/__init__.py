from src.utils.args_parser import parse_args
from src.utils.logging import setup_logging

args = parse_args()
setup_logging(args.log_level)
