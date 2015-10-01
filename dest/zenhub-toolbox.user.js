// ==UserScript==
// @name         ZenHub Toolbox
// @namespace    https://agate.github.com
// @version      1.0.0
// @description  Tools for ZenHub
// @author       agate
// @match        https://github.com/*
// @grant        none
// ==/UserScript==

(function() {
  var $btn, appendItem, dump;

  dump = function() {
    var $pipelines, $zhDump, pipelines, results;
    $pipelines = $('.zh-board-pipelines');
    pipelines = $pipelines.find('.zh-pipeline').map(function(idx, ele) {
      var $pipeline, issues, pipelineCount, pipelineName;
      $pipeline = $(ele);
      pipelineName = $pipeline.find('.zh-pipeline-name').text().trim();
      pipelineCount = $pipeline.find('.zh-pipeline-count').text().trim().replace(/[^\d]/g, '');
      issues = $pipeline.find('.zh-pipeline-issues > .zh-pipeline-issue').map(function(idx, ele) {
        var $issue, issueAssignee, issueId, issueLabels, issueTitle;
        $issue = $(ele);
        issueId = $issue.find('.zh-pipeline-issue-title .zh-pipeline-issue-number').text().replace('#', '').trim();
        issueTitle = $issue.find('.zh-pipeline-issue-title').contents().filter(function() {
          return this.nodeType === 3;
        }).map(function() {
          return this.nodeValue;
        }).get().join('').trim();
        issueAssignee = $issue.find('.zh-pipeline-issue-assignee a').attr('original-title');
        issueLabels = $issue.find('.zh-issue-meta .zh-issue-label').map(function() {
          return $(this).data('name');
        }).get();
        return {
          id: issueId,
          title: issueTitle,
          assignee: issueAssignee,
          labels: issueLabels
        };
      }).get();
      return {
        name: pipelineName,
        count: pipelineCount,
        issues: issues
      };
    }).get();
    results = {
      pipelines: pipelines
    };
    $zhDump = $("<div id=\"zh-dump\">\n  <style>\n    #zh-dump {\n      position: fixed;\n      top: 0;\n      right: 0;\n      left: 0;\n      bottom: 0;\n      background-color: black;\n      z-index: 10000;\n    }\n    #zh-dump .close {\n      position: absolute;\n      top: 10px;\n      right: 10px;\n      border: 1px solid;\n      width: 20px;\n      text-align: center;\n      text-decoration: none !important;\n      color: white;\n    }\n    #zh-dump .textarea-wrapper {\n      position: fixed;\n      padding: 30px;\n      top: 30px;\n      bottom: 30px;\n      left: 30px;\n      right: 30px;\n    }\n    #zh-dump textarea {\n      width: 100%;\n      height: 100%;\n    }\n  </style>\n  <a href=\"javascript:void(0);\" class=\"close\">X</a>\n  <div class=\"textarea-wrapper\">\n    <textarea></textarea>\n  </div>\n</div>");
    $zhDump.find('textarea').val(JSON.stringify(results, null, 2));
    $zhDump.find('a.close').click(function() {
      return $zhDump.remove();
    });
    return $zhDump.appendTo($('body'));
  };

  appendItem = function() {
    var $nav;
    $nav = $('.zh-board-menu .tabnav-right');
    if ($nav.length) {
      return $nav.append($btn);
    } else {
      return setTimeout(appendItem, 1000);
    }
  };

  $btn = $("<li class=\"zh-board-menu-itemgroup\">\n  <div class=\"zh-board-menu-item\">\n    <a class=\"btn btn-sm\" style=\"padding: 3px 10px\">\n      Dump\n    </a>\n  </div>\n</li>").click(dump);

  appendItem();

}).call(this);
