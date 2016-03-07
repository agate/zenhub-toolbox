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

toHash = ->
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

showDialog = (body) ->
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
  $zhDump.find('textarea').val(body)
  $zhDump.find('a.close').click ->
    $zhDump.remove()
  $zhDump.appendTo($('body'))

dump = ->
  body = JSON.stringify(toHash(), null, 2)
  showDialog(body)

okrs = ->
  baseUrl = $('.entry-title [itemprop=name] a').prop('href')
  pipelines = toHash().pipelines
  issues =
    yes: []
    maybe: []

  for pipeline in pipelines
    if pipeline.name == 'To Do' || pipeline.name == 'Pending'
      issues.yes = issues.yes.concat(pipeline.issues)
    else
      if pipeline.name == 'Maybe'
        issues.maybe = issues.maybe.concat(pipeline.issues)

  issues.yes.sort (a, b) ->
    res = parseInt(a.id) - parseInt(b.id)
    res
  issues.maybe.sort (a, b) ->
    res = parseInt(a.id) - parseInt(b.id)
    res

  body = """
    * Plan
        * Front
            * YES
    #{issues.yes.map((issue) => "            * #{issue.title} [##{issue.id}](#{baseUrl}/issues/#{issue.id})").join("\n")}
            * Maybe
    #{issues.maybe.map((issue) => "            * #{issue.title} [##{issue.id}](#{baseUrl}/issues/#{issue.id})").join("\n")}
    * Out of Plan
  """

  showDialog(body)

appendItem = ($btn) ->
  $nav = $('.zh-board-menu .tabnav-left')
  if $nav.length
    $nav.append($btn)
  else
    setTimeout ->
      appendItem($btn)
    , 1000

btns =
  dump: $("""
    <li class="zh-board-menu-itemgroup">
      <div class="zh-board-menu-item">
        <a class="btn btn-sm" style="padding: 3px 10px">
          Dump
        </a>
      </div>
    </li>
  """).click(dump),
  okrs: $("""
    <li class="zh-board-menu-itemgroup">
      <div class="zh-board-menu-item">
        <a class="btn btn-sm" style="padding: 3px 10px">
          OKRs
        </a>
      </div>
    </li>
  """).click(okrs)

for name, btn of btns
  appendItem(btn)
