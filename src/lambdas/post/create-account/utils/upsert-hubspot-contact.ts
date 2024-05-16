import HubspotClient from '@gravity-haus/gh-common/dist/hubspot-client/hubspot-client';

import getFormattedDate from '@gravity-haus/gh-common/dist/date/get-formatted-date/get-formatted-date';
import parseGHPlan from '@gravity-haus/gh-common/dist/parse-gh-plan/parse-gh-plan';

interface UpsertHubspotContactType {
  email: string;
  firstName: string;
  lastName: string;
  dateOfBirth: string;
  phoneNumber: string;
  address1: string;
  postalCode: string;
  city: string;
  state: string;
  familyMembers?: any[];
  planId: string;
  memberCode: string;
  referralCode: string;
  childAccount?: string;
  parentAccount?: string;
  groupCode?: string;
}

const getPlanType = (ghPlan: any): any => {
  if (ghPlan.gh_membership_type === 'plan_gh_allin') {
    ghPlan.gh_membership_type = 'plan_gh_all_in';
  } else if (ghPlan.gh_membership_type === 'plan_gh_allinlocal') {
    ghPlan.gh_membership_type = 'plan_gh_all_in_local';
  } else if (ghPlan.gh_membership_type === 'plan_gh_traveler') {
    ghPlan.gh_membership_type = 'plan_gh_weekender';
  }

  const location = ghPlan.gh_membership_location.toLowerCase();
  if (location === 'anylocation') ghPlan.gh_membership_location = '';
  if (location === 'truckee') ghPlan.gh_membership_location = 'Tahoe';

  return ghPlan;
};

export const upsertHubspotContact = async (data: UpsertHubspotContactType): Promise<any> => {
  try {
    const hubspotClient = HubspotClient.getInstance();

    const parsedPlanId = getPlanType(parseGHPlan(data.planId.replace('c1', '')));

    const isPif = data.planId.includes('_pif');

    const familyMembers = (data?.familyMembers || [])
      .map((member, index) => {
        const dob = new Date(member.dateOfBirth).getTime();

        return [
          { property: `Family_Member_First_Name_${index + 1}`, value: member.firstName },
          { property: `Family_Member_Last_Name_${index + 1}`, value: member.lastName },
          { property: `Family_Member_Email_${index + 1}`, value: member.email },
          { property: `Family_Member_DOB_${index + 1}`, value: dob },
        ];
      })
      .flat();

    const dateOfBirth = new Date(data.dateOfBirth);

    const properties = [
      { property: 'gh_contact_type', value: 'Member' },
      { property: 'master_source_owner', value: 'GH_Website' },
      { property: 'email', value: data.email },
      { property: 'firstname', value: data.firstName },
      { property: 'lastName', value: data.lastName },
      { property: 'date_of_birth', value: getFormattedDate(dateOfBirth, 'MM/DD/YYYY') },
      { property: 'birth_date', value: dateOfBirth.setUTCHours(0, 0, 0, 0) },
      { property: 'phone', value: data.phoneNumber },
      { property: 'address', value: data.address1 },
      { property: 'city', value: data.city },
      { property: 'state', value: data.state },
      { property: 'zip', value: data.postalCode },
      { property: 'child_account', value: data.childAccount || '' },
      { property: 'parent_account', value: data.parentAccount || '' },
      { property: 'duration', value: parsedPlanId.gh_membership_duration },
      { property: 'pif_or_monthly', value: isPif ? 'PIF' : 'Monthly' },
      { property: 'gh_membership_group_type', value: parsedPlanId.gh_membership_group_type },

      {
        property: 'is_a_capital_one_member',
        value: data.planId.includes('c1') ? 'Yes_Capital_One_Member' : 'Not_Capital_One_Member',
      },

      { property: 'member_code', value: data.memberCode },
      { property: 'group_code', value: data.groupCode },

      { property: 'referral_code', value: data.referralCode },

      { property: 'gh_membership_location', value: parsedPlanId.gh_membership_location },
      { property: 'gh_membership_type', value: parsedPlanId.gh_membership_type },

      ...familyMembers,
    ];

    const contact = await hubspotClient.createOrUpdateContactByEmail(data.email, properties);
    return contact;
  } catch (error) {
    throw error;
  }
};

export default upsertHubspotContact;
