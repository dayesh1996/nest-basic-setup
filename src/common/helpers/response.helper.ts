// common/helpers/response.helper.ts

export function successResponse<T>(
  data: T,
  message = 'Success',
  statusCode = 200,
) {
  return { statusCode, message, data };
}

export function getSuccessResponse<T>(
  data: T,
  statusCode = 200,
) {
  return { statusCode, data };
}
export function errorResponse(
  message = 'Error',
  statusCode = 400,
  errors: any = null,
  path?: string,
) {
  return {
    statusCode,
    message,
    errors, // optional details (like validation issues)
    path,
    timestamp: new Date().toISOString(),
  };
}
