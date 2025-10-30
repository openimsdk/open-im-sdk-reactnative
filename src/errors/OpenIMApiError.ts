export class OpenIMApiError extends Error {
  name: string = 'OpenIMApiError';
  code: number;
  message: string;

  constructor(code: number, message: string) {
    super(message);
    this.code = code;
    this.message = message;
  }
}
