'use strict';
const swaggerJSON = require(`/opt/nodejs/swagger.json`);

const applicationName = 'Gravity Haus API Documentation';

const corsHeaders = {
    'Access-Control-Allow-Headers': 'Content-Type, X-Amz-Date, Authorization, X-Api-Key, x-requested-with',
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Methods': '*',
    'content-type': 'application/json'
  };

exports.swagger = async (event) => {
    if (event.path.includes('/swagger.json')) {
        return {
            statusCode: 200,
            headers: corsHeaders,
            body: JSON.stringify(swaggerJSON)
        }
    }

    const body = `<!DOCTYPE html>
        <html lang="en">
        <head>
            <meta charset="UTF-8">
            <title>${applicationName}</title>
            <link rel="stylesheet" href="https://unpkg.com/swagger-ui-dist@3/swagger-ui.css">
        </head>
        <body>
            <div id="swagger"></div>
            <script src="https://unpkg.com/swagger-ui-dist@3/swagger-ui-bundle.js"></script>
            <script>
              SwaggerUIBundle({
                dom_id: '#swagger',
                url: '/Prod/swagger.json'
            });
            </script>
        </body>
        </html>`;

    return {
        statusCode: 200,
        headers: {
            ['Content-Type']: 'text/html',
        },
        body
    };
}