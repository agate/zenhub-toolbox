// ==UserScript==
// @name         ZenHub Toolbox
// @namespace    https://agate.github.com
// @version      1.1.0
// @description  Tools for ZenHub
// @author       agate
// @match        https://github.com/*
// @grant        none
// ==/UserScript==

(function() {
  var $btn, SELECTORS, appendItem, dump;

  SELECTORS = {
    pipelines: '.zh-board-pipelines .zh-pipeline',
    pipeline: {
      name: '.zh-pipeline-name',
      count: '.zh-pipeline-count',
      issues: '.zh-pipeline-issues .zh-pipeline-issue',
      issue: {
        id: '.zh-issuecard-number',
        title: '.zh-issuecard-title',
        assignee: '.zh-issuecard-avatar-container a',
        labels: '.zh-issuecard-meta .zh-issue-label'
      }
    }
  };

  dump = function() {
    var $pipelines, $zhDump, pipelines, results;
    $pipelines = $(SELECTORS.pipelines);
    pipelines = $pipelines.map(function(idx, ele) {
      var $count, $issues, $name, $pipeline, count, issues, name;
      $pipeline = $(ele);
      $name = $pipeline.find(SELECTORS.pipeline.name);
      $count = $pipeline.find(SELECTORS.pipeline.count);
      $issues = $pipeline.find(SELECTORS.pipeline.issues);
      name = $name.text().trim();
      count = $count.text().trim().replace(/[^\d]/g, '');
      issues = $issues.map(function(idx, ele) {
        var $assignee, $id, $issue, $labels, $title, assignee, id, labels, title;
        $issue = $(ele);
        $id = $issue.find(SELECTORS.pipeline.issue.id);
        $title = $issue.find(SELECTORS.pipeline.issue.title);
        $assignee = $issue.find(SELECTORS.pipeline.issue.assignee);
        $labels = $issue.find(SELECTORS.pipeline.issue.labels);
        id = $id.text().replace('#', '').trim();
        title = $title.text().trim();
        assignee = $assignee.attr('aria-label');
        labels = $labels.map(function() {
          return $(this).data('name');
        }).get();
        return {
          id: id,
          title: title,
          assignee: assignee,
          labels: labels
        };
      }).get();
      return {
        name: name,
        count: count,
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
