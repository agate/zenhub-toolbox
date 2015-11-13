SELECTORS =
  pipelines: '.zh-board-pipelines .zh-pipeline'
  pipeline:
    name: '.zh-pipeline-name'
    count: '.zh-pipeline-count'
    issues: '.zh-pipeline-issues .zh-pipeline-issue'
    issue:
      id: '.zh-issuecard-number'
      title: '.zh-issuecard-title'
      assignee: '.zh-issuecard-avatar-container a'
      labels: '.zh-issuecard-meta .zh-issue-label'

dump = ->
  $pipelines = $(SELECTORS.pipelines)

  pipelines = $pipelines.map (idx, ele) ->
    $pipeline = $(ele)
    $name = $pipeline.find(SELECTORS.pipeline.name)
    $count = $pipeline.find(SELECTORS.pipeline.count)
    $issues = $pipeline.find(SELECTORS.pipeline.issues)

    name = $name.text().trim()
    count = $count.text().trim().replace(/[^\d]/g, '')
    issues = $issues.map (idx, ele) ->
      $issue = $(ele)
      $id = $issue.find(SELECTORS.pipeline.issue.id)
      $title = $issue.find(SELECTORS.pipeline.issue.title)
      $assignee = $issue.find(SELECTORS.pipeline.issue.assignee)
      $labels = $issue.find(SELECTORS.pipeline.issue.labels)

      id = $id.text().replace('#', '').trim()
      title = $title.text().trim()
      assignee = $assignee.attr('aria-label')
      labels = $labels.map ->
        $(@).data('name')
      .get()

      {
        id: id
        title: title
        assignee: assignee
        labels: labels
      }
    .get()

    {
      name: name
      count: count
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
