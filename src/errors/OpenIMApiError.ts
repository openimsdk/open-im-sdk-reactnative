export class OpenIMApiError extends Error {
  name: string = 'OpenIMApiError';
  code: number;
  message: string;
  operationID: string;

  constructor(code: number, message: string, operationID: string) {
    super(message);
    this.code = code;
    this.message = message;
    this.operationID = operationID;
  }

  // Error object's message and stack properties are non-enumerable by default.
  // Override toJSON() to ensure the message property is properly serialized.
  toJSON() {
    return {
      name: this.name,
      operationID: this.operationID,
      code: this.code,
      message: this.message,
    };
  }
}
