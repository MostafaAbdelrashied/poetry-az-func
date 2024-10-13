import azure.functions as func
from loguru import logger

from src.main import main

app = func.FunctionApp()


@app.timer_trigger(
    schedule="*/5 * * * * *",
    arg_name="myTimer",
    run_on_startup=False,
    use_monitor=False,
)
def TimerTriggerFunction(myTimer: func.TimerRequest) -> None:
    if myTimer.past_due:
        logger.info("The timer is past due!")

    logger.info("Python timer trigger function executed.")
    results = main()
    logger.info(f"Results: {results}")
    logger.info("Python timer trigger function finished.")
