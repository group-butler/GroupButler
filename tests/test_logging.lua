local logging = require "logging"

-- Isn't a real test yet, but at least it will catch any big errors

logging.info("starting up")
logging.error("startup failed: {name} timed out ({timeout})", {name="telegram", timeout=5})
logging.debug("message from {user}", {user="abc"})

logging.formatter = logging.json_log_formatter

logging.info("starting up")
logging.error("startup failed: {name} timed out ({timeout})", {name="telegram", timeout=5})
logging.debug("message from {user}", {user="abc"})
