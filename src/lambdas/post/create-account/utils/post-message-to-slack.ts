import capitalizeFirstLetter from '@gravity-haus/gh-common/dist/capitalize-first-letter/capitalize-first-letter';
import { WebClient, ChatPostMessageArguments } from '@slack/web-api';
const slackClient = new WebClient(process.env.SLACK_API_KEY);

const postMessage = async (blocks: any, attachments: any, slackChannel?: string) => {
  let channel = process.env.ENV === 'prod' ? 'C04MCJ93UA1' : 'C03NFLB2HMM';
  if (slackChannel) channel = slackChannel;
  if (process.env.ENV !== 'prod') channel = 'C03NFLB2HMM';

  try {
    await slackClient.chat.postMessage({
      channel,
      blocks,
      attachments,
    });
  } catch (error) {
    throw error; // TODO: set up logs and log error
  }
};

const blockHeader = (header: string) => {
  return [
    {
      type: 'divider',
    },
    {
      type: 'header',
      text: {
        type: 'plain_text',
        text: header,
      },
    },
  ];
};

const attachmentField = (title: string, value: string): any => {
  return [
    {
      title: title
        .split(/(?=[A-Z])/)
        .map((x) => capitalizeFirstLetter(x))
        .join(' '),
      short: true,
    },
    { value, short: true },
  ];
};

interface AttachmentFieldType {
  [key: string]: string;
}

export const reportToSlack = async (data: {
  header: string;
  pretext?: string;
  values: AttachmentFieldType;
  color: string;
  slackChannel?: string;
}) => {
  if (process.env.SEEDS === 'true') return;

  const { header, values, pretext, color } = data;

  const blocks = blockHeader(header);

  const fields = Object.entries(values).map((x) => {
    return attachmentField(x[0], x[1]);
  });

  const attachment = {
    color,
    fields: fields.flat(),
  } as any;

  if (pretext) attachment.pretext = pretext;

  const attachments = [attachment] as unknown as ChatPostMessageArguments['attachments'];

  await postMessage(blocks, attachments, data.slackChannel);
};
