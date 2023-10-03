class HttpError extends Error {
  constructor(supportMessage, code, userMessage) {
    super(supportMessage);
    this.name = "HttpError";
    this.code = code;
    this.userMessage = userMessage;
  }
}

class Error400 extends HttpError {
  constructor() {
    super(
      "Invalid Request Body",
      400,
      "Oops! It seems that the request you made contains invalid or malformed syntax. Please check your input and try again."
    );
  }
}

class Error403 extends HttpError {
  constructor(msg) {
    super(
      "You don't have permission to access this resource",
      403,
      msg ||
        "Your request could not be processed and has been rejected. Kindly contact administrator as you are not authorized to view the content."
    );
  }
}

class Error404 extends HttpError {
  constructor(msg) {
    super(
      msg || "Resource/ page unavailable",
      404,
      "Your request could not be processed, as the resource which you are searching for could not be found. Resource might be moved, deleted or mistyped in the URL."
    );
  }
}
class Error500 extends HttpError {
  constructor(userMessage) {
    super(
      "An unexpected error has occurred. Please reach out to the CES team.",
      500,
      userMessage || "The request was invalid or cannot be served."
    );
  }
}
module.exports = {
  Error403,
  Error404,
  Error400,
  Error500,
};
