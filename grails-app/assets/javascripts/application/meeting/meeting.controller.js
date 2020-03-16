/*
 * Copyright (c) 2020 Kagilum SAS.
 *
 * This file is part of iceScrum.
 *
 * iceScrum is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as published by
 * the Free Software Foundation, either version 3 of the License.
 *
 * iceScrum is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with iceScrum.  If not, see <http://www.gnu.org/licenses/>.
 *
 * Authors:
 *
 * Vincent Barrier (vbarrier@kagilum.com)
 * Nicolas Noullet (nnoullet@kagilum.com)
 *
 */
extensibleController('meetingCtrl', ['$scope', '$injector', 'AppService', 'MeetingService', 'Meeting', 'Session', function($scope, $injector, AppService, MeetingService, Meeting, Session) {
    // Functions
    $scope.createMeeting = function(context, provider) {
        if (provider.enabled) {
            var meetingName = context.name ? context.name : $scope.message('is.ui.collaboration.meeting.default');
            var meeting = new Meeting();
            meeting.provider = provider.id;
            meeting.subject = meetingName;
            meeting.startDate = moment().format();
            if (context) {
                meeting.contextId = context.id;
                meeting.contextType = context.class;
            }
            provider.createMeeting(context, meeting, $scope).then(function(meetingData) {
                if (meetingData.videoLink || meetingData.phone) {
                    meeting.videoLink = meetingData.videoLink;
                    meeting.phone = meetingData.phone ? meetingData.phone : null;
                    meeting.pinCode = meetingData.pinCode ? meetingData.pinCode : null;
                    meeting.providerEventId = meetingData.providerEventId;
                    var workspace = Session.getWorkspace();
                    MeetingService.save(meeting, workspace, context).then(function(meeting) {
                        $scope.meetings.push(meeting);
                        $scope.meetings_count = $scope.meetings.length;
                    });
                }
            });
        } else {
            $scope.showAppsModal($scope.message('is.ui.apps.tag.collaboration'), true)
        }
    };

    $scope.stopMeeting = function(meeting) {
        var provider = _.find(isSettings.meeting.providers, {id: meeting.provider});
        meeting.endDate = moment().format();
        provider.stopMeeting(meeting, $scope).then(function(meetingData) {
            var workspace = Session.getWorkspace();
            MeetingService.update(meeting, workspace).then(function(){
                meetings = _.filter($scope.meetings, { endDate:null });
                $scope.meetings = meetings;
                $scope.meetings_count = meetings.length;
            });
        });
    };
    $scope.authorizedMeeting = MeetingService.authorizedMeeting;
    // Init
    $scope.injector = $injector;
    $scope.$watch('project.simpleProjectApps', function() {
        $scope.providers = _.each(isSettings.meeting.providers, function(provider) {
            provider.enabled = AppService.authorizedApp('use', provider.id, $scope.project);
        });
    }, true);

    var workspace = Session.getWorkspace();
    $scope.context = $scope.selected ? $scope.selected : false;
    MeetingService.list(workspace, $scope.context).then(function(meetings) {
        meetings = _.filter(meetings, { endDate:null });
        $scope.meetings = meetings;
        $scope.meetings_count = meetings.length;
    });
}]);