import azure.functions as func
from loguru import logger

from src.main import main

app = func.FunctionApp()


@app.function_name(name="TimerTriggerFunction")
@app.timer_trigger(
    # once per week at 00:00:00 UTC
    schedule="0 0 1 * *",
    arg_name="myTimer",
    run_on_startup=True,
    use_monitor=False,
)
def timer_demo(myTimer: func.TimerRequest) -> None:
    if myTimer.past_due:
        logger.warning("The timer is past due!")

    logger.info("Timer trigger function started.")
    results = main()
    logger.info(f"Results: {results}")
    logger.info("Timer trigger function finished.")
