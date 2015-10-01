dump = ->
  $pipelines = $('.zh-board-pipelines')
  pipelines = $pipelines.find('.zh-pipeline').map (idx, ele) ->
    $pipeline = $(ele)

    pipelineName = $pipeline.find('.zh-pipeline-name').text().trim()
    pipelineCount = $pipeline.find('.zh-pipeline-count').text().trim().replace(/[^\d]/g, '')
    issues = $pipeline.find('.zh-pipeline-issues > .zh-pipeline-issue').map (idx, ele) ->
      $issue = $(ele)
      issueId = $issue.find('.zh-pipeline-issue-title .zh-pipeline-issue-number').text().replace('#', '').trim()
      issueTitle = $issue.find('.zh-pipeline-issue-title').contents().filter ->
        @nodeType == 3
      .map ->
        @nodeValue
      .get().join('').trim()
      issueAssignee = $issue.find('.zh-pipeline-issue-assignee a').attr('original-title')
      issueLabels = $issue.find('.zh-issue-meta .zh-issue-label').map ->
        $(@).data('name')
      .get()

      {
        id: issueId
        title: issueTitle
        assignee: issueAssignee
        labels: issueLabels
      }
    .get()

    {
      name: pipelineName
      count: pipelineCount
      issues: issues
    }
  .get()

  results =
    pipelines: pipelines

  $zhDump = $("""
    <div id="zh-dump">
      <style>
        #zh-dump {
          position: fixed;
          top: 0;
          right: 0;
          left: 0;
          bottom: 0;
          background-color: black;
          z-index: 10000;
        }
        #zh-dump .close {
          position: absolute;
          top: 10px;
          right: 10px;
          border: 1px solid;
          width: 20px;
          text-align: center;
          text-decoration: none !important;
          color: white;
        }
        #zh-dump .textarea-wrapper {
          position: fixed;
          padding: 30px;
          top: 30px;
          bottom: 30px;
          left: 30px;
          right: 30px;
        }
        #zh-dump textarea {
          width: 100%;
          height: 100%;
        }
      </style>
      <a href="javascript:void(0);" class="close">X</a>
      <div class="textarea-wrapper">
        <textarea></textarea>
      </div>
    </div>
  """)
  $zhDump.find('textarea').val(JSON.stringify(results, null, 2))
  $zhDump.find('a.close').click ->
    $zhDump.remove()
  $zhDump.appendTo($('body'))

appendItem = ->
  $nav = $('.zh-board-menu .tabnav-right')
  if $nav.length
    $nav.append($btn)
  else
    setTimeout(appendItem, 1000)

$btn = $("""
  <li class="zh-board-menu-itemgroup">
    <div class="zh-board-menu-item">
      <a class="btn btn-sm" style="padding: 3px 10px">
        Dump
      </a>
    </div>
  </li>
""").click(dump)

appendItem()
