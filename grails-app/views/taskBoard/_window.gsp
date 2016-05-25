%{--
- Copyright (c) 2015 Kagilum SAS
-
- This file is part of iceScrum.
-
- iceScrum is free software: you can redistribute it and/or modify
- it under the terms of the GNU Affero General Public License as published by
- the Free Software Foundation, either version 3 of the License.
-
- iceScrum is distributed in the hope that it will be useful,
- but WITHOUT ANY WARRANTY; without even the implied warranty of
- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- GNU General Public License for more details.
-
- You should have received a copy of the GNU Affero General Public License
- along with iceScrum.  If not, see <http://www.gnu.org/licenses/>.
-
- Authors:
-
- Vincent Barrier (vbarrier@kagilum.com)
- Nicolas Noullet (nnoullet@kagilum.com)
--}%
<is:window windowDefinition="${windowDefinition}">
    <div class="panel panel-light"
         ng-if="sprint"
         ng-class="{'sortable-disabled': !isSortingTaskBoard(sprint), 'sprint-not-done': sprint.state != sprintStatesByName.DONE}">
        <div class="panel-heading">
            <h3 class="panel-title small-title">
                <div class="btn-toolbar"
                     ng-controller="taskCtrl">
                    {{ (sprint | sprintName) + ' - ' + (sprint.state | i18n: 'SprintStates') }}
                    <a ng-if="authorizedTask('create', {sprint: sprint})"
                       ui-sref="taskBoard.task.new"
                       class="btn btn-primary pull-right">${message(code: "todo.is.ui.task.new")}</a>
                    <a class="btn btn-default pull-right"
                       href="{{ ::openSprintUrl(sprint) }}"
                       uib-tooltip="${message(code: 'todo.is.ui.details')}">
                        <i class="fa fa-info-circle"></i>
                    </a>
                    <div class="btn-group pull-right"
                         uib-dropdown>
                        <button type="button"
                                ng-if="isSortableTaskBoard(sprint)"
                                class="btn btn-default"
                                ng-click="enableSortable()"
                                uib-tooltip="{{ isSortingTaskBoard(sprint) ? '${message(code: /todo.is.ui.sortable.enabled/)}' : '${message(code: /todo.is.ui.sortable.enable/)}' }}">
                            <span ng-class="isSortingTaskBoard(sprint) ? 'text-success' : 'forbidden-stack text-danger'" class="fa fa-hand-pointer-o"></span>
                        </button>
                        <button class="btn btn-default"
                                uib-dropdown-toggle
                                uib-tooltip="${message(code:'todo.is.ui.filters')}"
                                type="button">
                            <span>{{ currentSprintFilter.name }}</span>
                            <span class="caret"></span>
                        </button>
                        <ul uib-dropdown-menu role="menu">
                            <li role="menuitem" ng-repeat="sprintFilter in sprintFilters">
                                <a ng-click="changeSprintFilter(sprintFilter)" href>{{ sprintFilter.name }}</a>
                            </li>
                        </ul>
                    </div>
                    <div class="btn-group pull-right visible-on-hover">
                        <button type="button"
                                class="btn btn-default"
                                uib-tooltip="${message(code: 'todo.is.ui.postit.size')}"
                                ng-click="postitSize(true)"><i class="fa fa-compress" ng-class="{'fa-compress fa-lg': app.postitSize == '', 'fa-compress': app.postitSize == 'postit-sm', 'fa-expand': app.postitSize == 'postit-xs'}"></i>
                        </button>
                        <button type="button"
                                class="btn btn-default"
                                uib-tooltip="${message(code:'is.ui.window.print')} (P)"
                                unavailable-feature="true"
                                hotkey="{'P': hotkeyClick }"><i class="fa fa-print"></i>
                        </button>
                        <button type="button"
                                class="btn btn-default"
                                uib-tooltip="${message(code:'is.ui.window.fullscreen')}"
                                ng-click="fullScreen()"><i class="fa fa-arrows-alt"></i>
                        </button>
                    </div>
                    <div class="sub-title text-muted">
                        {{ sprint.startDate | dayShorter }} <i class="fa fa-long-arrow-right"></i> {{ sprint.endDate | dayShorter }}
                    </div>
                </div>
            </h3>
        </div>
        <div class="panel-body" id="tasks-board" ng-controller="taskCtrl">
            <table class="table" selectable="selectableOptions" sticky-list="#tasks-board">
                <thead>
                <tr class="table-header sticky-header sticky-stack">
                    <th ng-if="sprint.state != sprintStatesByName.DONE">
                        <span>${message(code: 'is.task.state.wait')} <span class="badge">{{ taskCountByState[taskStatesByName.TODO] }}</span></span>
                    </th>
                    <th ng-if="sprint.state == sprintStatesByName.IN_PROGRESS">
                        <span>${message(code: 'is.task.state.inprogress')} <span class="badge">{{ taskCountByState[taskStatesByName.IN_PROGRESS] }}</span></span>
                    </th>
                    <th ng-if="sprint.state != sprintStatesByName.TODO">
                        <span>${message(code: 'is.task.state.done')} <span class="badge">{{ taskCountByState[taskStatesByName.DONE] }}</span></span>
                    </th>
                </tr>
                </thead>
                <tbody class="task-type">
                    <tr class="sticky-header">
                        <td colspan="{{ sprint.state != sprintStatesByName.IN_PROGRESS ? 1 : 3 }}">
                            <h3 class="title">${message(code: 'is.ui.sprintPlan.kanban.urgentTasks')}</h3>
                        </td>
                    </tr>
                    <tr>
                        <td class="postits grid-group"
                            ng-class="hasSelected() ? 'has-selected' : ''"
                            ng-model="tasksByTypeByState[taskTypesByName.URGENT][taskState]"
                            ng-init="taskType = taskTypesByName.URGENT"
                            as-sortable="taskSortableOptions | merge: sortableScrollOptions('tbody')"
                            is-disabled="!isSortingTaskBoard(sprint)"
                            ng-repeat="taskState in sprintTaskStates">
                            <div ng-repeat="task in tasksByTypeByState[taskTypesByName.URGENT][taskState] | search"
                                 ng-class="{ 'is-selected': isSelected(task) }"
                                 selectable-id="{{ ::task.id }}"
                                 as-sortable-item
                                 class="postit-container">
                                <div ng-include="'task.html'"></div>
                            </div>
                            <div ng-if="taskState == 0 && authorizedTask('create', {sprint: sprint})" class="postit-container">
                                <div class="add-task postit {{ app.postitSize }}">
                                    <a class="btn btn-primary"
                                       ng-click="openNewTaskByType(taskTypesByName.URGENT)"
                                       href><g:message code="todo.is.ui.task.new"/>
                                    </a>
                                </div>
                            </div>
                        </td>
                    </tr>
                    <tr class="sticky-header">
                        <td colspan="{{ sprint.state != sprintStatesByName.IN_PROGRESS ? 1 : 3 }}">
                            <h3 class="title">${message(code: 'is.ui.sprintPlan.kanban.recurrentTasks')}</h3>
                        </td>
                    </tr>
                    <tr>
                        <td class="postits grid-group"
                            ng-class="hasSelected() ? 'has-selected' : ''"
                            ng-model="tasksByTypeByState[taskTypesByName.RECURRENT][taskState]"
                            ng-init="taskType = taskTypesByName.RECURRENT"
                            as-sortable="taskSortableOptions | merge: sortableScrollOptions('tbody')"
                            is-disabled="!isSortingTaskBoard(sprint)"
                            ng-repeat="taskState in sprintTaskStates">
                            <div ng-repeat="task in tasksByTypeByState[taskTypesByName.RECURRENT][taskState] | search"
                                 ng-class="{ 'is-selected': isSelected(task) }"
                                 selectable-id="{{ ::task.id }}"
                                 as-sortable-item
                                 class="postit-container">
                                <div ng-include="'task.html'"></div>
                            </div>
                            <div ng-if="taskState == 0 && authorizedTask('create', {sprint: sprint})" class="postit-container">
                                <div class="add-task postit {{ app.postitSize }}">
                                    <a class="btn btn-primary"
                                       ng-click="openNewTaskByType(taskTypesByName.RECURRENT)"
                                       href><g:message code="todo.is.ui.task.new"/>
                                    </a>
                                </div>
                            </div>
                        </td>
                    </tr>
                </tbody>
                <tbody ng-repeat="story in sprint.stories | filter: storyFilter | search | orderBy: 'rank'" ng-class="{'story-done': story.state == 7}">
                    <tr class="sticky-header list-group">
                        <td colspan="3" class="postit-container story-container" ng-controller="storyCtrl" ng-click="selectStory($event, story.id)">
                            <div ng-include="'story.html'" ng-init="disabledGradient = true"></div>
                        </td>
                    </tr>
                    <tr class="postits grid-group" ng-class="{'sortable-disabled': !isSortingStory(story)}" style="border-left: 15px solid {{ story.feature ? story.feature.color : '#f9f157' }};">
                        <td class="postits grid-group"
                            ng-class="hasSelected() ? 'has-selected' : ''"
                            ng-model="tasksByStoryByState[story.id][taskState]"
                            as-sortable="taskSortableOptions | merge: sortableScrollOptions('tbody')"
                            is-disabled="!isSortingTaskBoard(sprint) || !isSortingStory(story)"
                            ng-repeat="taskState in sprintTaskStates">
                            <div ng-repeat="task in tasksByStoryByState[story.id][taskState]"
                                 ng-class="{ 'is-selected': isSelected(task) }"
                                 selectable-id="{{ ::task.id }}"
                                 as-sortable-item
                                 class="postit-container">
                                <div ng-include="'task.html'"></div>
                            </div>
                            <div ng-if="taskState == 0 && authorizedTask('create', {parentStory: story})" class="postit-container">
                                <div class="add-task postit {{ app.postitSize }}">
                                    <a class="btn btn-primary"
                                       ng-click="openNewTaskByStory(story)"
                                       href><g:message code="todo.is.ui.task.new"/>
                                    </a>
                                </div>
                            </div>
                        </td>
                    </tr>
                </tbody>
                <tbody ng-repeat="story in ghostStories | filter: storyFilter | search | orderBy: 'id'" class="story-ghost">
                    <tr class="sticky-header list-group">
                        <td colspan="3" class="postit-container story-container" ng-controller="storyCtrl" ng-click="selectStory($event, story.id)">
                            <div ng-include="'story.html'" ng-init="disabledGradient = true"></div>
                        </td>
                    </tr>
                    <tr class="postits grid-group sortable-disabled" style="border-left: 15px solid {{ story.feature ? story.feature.color : '#f9f157' }};">
                        <td class="postits grid-group"
                            ng-class="hasSelected() ? 'has-selected' : ''"
                            ng-model="tasksByStoryByState[story.id][taskState]"
                            as-sortable
                            is-disabled="true"
                            ng-repeat="taskState in sprintTaskStates">
                            <div ng-repeat="task in tasksByStoryByState[story.id][taskState]"
                                 ng-class="{ 'is-selected': isSelected(task) }"
                                 selectable-id="{{ ::task.id }}"
                                 as-sortable-item
                                 class="postit-container">
                                <div ng-include="'task.html'"></div>
                            </div>
                        </td>
                    </tr>
                </tbody>
                <tr ng-if="sprint.stories.length == 0">
                    <td colspan="{{ sprint.state != sprintStatesByName.IN_PROGRESS ? 1 : 3 }}">
                        <div class="empty-view">
                            <p class="help-block">${message(code: 'todo.is.ui.story.empty.taskBoard')}</p>
                            <a class="btn btn-primary"
                               href="#/planning/{{ sprint.parentRelease.id }}/sprint/{{ sprint.id }}">
                                <i class="fa fa-inbox"></i> ${message(code: 'todo.is.ui.planning')}
                            </a>
                        </div>
                    </td>
                </tr>
            </table>
        </div>
    </div>
    <div ng-if="!sprint"
         class="panel panel-light">
        <div class="panel-body">
            <div class="empty-view">
                <p class="help-block">${message(code: 'todo.is.ui.taskBoard.empty')}<p>
                <a class="btn btn-primary"
                   href="#planning">
                    <i class="fa fa-calendar"></i> ${message(code: 'todo.is.ui.planning')}
                </a>
            </div>
        </div>
    </div>
</is:window>