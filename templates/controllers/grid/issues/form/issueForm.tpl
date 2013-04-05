{**
 * templates/controllers/grid/issues/form/issueData.tpl
 *
 * Copyright (c) 2003-2013 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * Form for creation and modification of an issue
 *}
<script>
	$(function() {ldelim}
		// Attach the form handler.
		$('#issueForm').pkpHandler(
			'$.pkp.controllers.form.FileUploadFormHandler',
			{ldelim}
				$uploader: $('#plupload'),
				uploaderOptions: {ldelim}
					uploadUrl: '{url|escape:javascript op="uploadStylesheet"}',
					baseUrl: '{$baseUrl|escape:javascript}'
				{rdelim}
			{rdelim}
		);
		$('input[id^="datePublished"]').datepicker({ldelim} dateFormat: 'yy-mm-dd' {rdelim});
		$('input[id^="openAccessDate"]').datepicker({ldelim} dateFormat: 'yy-mm-dd' {rdelim});
	{rdelim});
</script>

<form class="pkp_form" id="issueForm" method="post" action="{url op="updateIssue" issueId=$issueId}">

	{fbvFormArea id="identificationArea" class="border" title="editor.issues.identification"}
		{fbvFormSection}
			{fbvElement type="text" label="issue.volume" id="volume" value=$volume maxlength="40" inline=true size=$fbvStyles.size.SMALL}
			{fbvElement type="text" label="issue.number" id="number" value=$number maxlength="40" inline=true size=$fbvStyles.size.SMALL}
			{fbvElement type="text" label="issue.year" id="year" value=$year maxlength="4" inline=true size=$fbvStyles.size.SMALL}
			{if $enablePublicIssueId}
				{fbvElement type="text" label="editor.issues.publicIssueIdentifier" id="publicIssueId" inline=true value=$publicIssueId size=$fbvStyles.size.SMALL}
			{/if}
		{/fbvFormSection}
		{fbvFormSection}
			{fbvElement type="text" label="issue.title" id="title" value=$title multilingual=true}
		{/fbvFormSection}
	{/fbvFormArea}

	{fbvFormArea id="identificationSelectionArea" class="border" title="editor.issues.issueIdentification" size=$fbvStyles.size.SMALL}
		{fbvFormSection list=true}
			{fbvElement type="checkbox" label="issue.volume" id="showVolume" checked=$showVolume inline=true value=1}
			{fbvElement type="checkbox" label="issue.number" id="showNumber" checked=$showNumber inline=true value=1}
			{fbvElement type="checkbox" label="issue.year" id="showYear" checked=$showYear inline=true value=1}
			{fbvElement type="checkbox" label="issue.title" id="showTitle" checked=$showTitle inline=true value=1}
		{/fbvFormSection}
	{/fbvFormArea}

	{fbvFormArea id="description" title="editor.issues.description"}
		{fbvElement type="textarea" id="description" value=$description multilingual=true rich=true}
	{/fbvFormArea}

	{fbvFormArea id="issueStatus" title="common.status" class="border"}
		{if $issue && $issue->getPublished()}
			{translate key="editor.issues.published"}
			{fbvElement type="text" label="common.date" id="datePublished" value=$datePublished|date_format:"%y-%m-%d" size=$fbvStyles.size.SMALL}
		{else}
			{translate key="editor.issues.unpublished"}
		{/if}

		{if $issue && $issue->getDateNotified()}
			<br/>
			{translate key="editor.usersNotified"}&nbsp;&nbsp;
			{$issue->getDateNotified()|date_format:$dateFormatShort}
		{/if}
	{/fbvFormArea}

	{if $currentJournal->getSetting('publishingMode') == $smarty.const.PUBLISHING_MODE_SUBSCRIPTION}
		{fbvFormArea id="issueAccessArea" title="editor.issues.access" class="border"}
			{fbvFormSection}
				{fbvElement type="select" id="accessStatus" label="editor.issues.accessStatus" from=$accessOptions selected=$accessStatus translate=false size=$fbvStyles.size.SMALL list=true}
			{/fbvFormSection}
			{fbvFormSection label="editor.issues.enableOpenAccessDate"}
				{fbvElement type="checkbox" id="enableOpenAccessDate" checked=$openAccessDate inline=true}
				{fbvElement type="text" label="editor.issues.accessDate" id="openAccessDate" value=$openAccessDate|date_format:"%y-%m-%d" size=$fbvStyles.size.SMALL inline=true}
			{/fbvFormSection}
		{/fbvFormArea}
	{/if}

	{fbvFormArea id="file"}
		{fbvFormSection title="editor.issues.styleFile"}
			<div id="plupload"></div>
			{if $styleFileName}
				{translate key="common.currentStyleSheet"}: <a href="{$publicFilesDir}/{$styleFileName|escape}" target="_blank" alt="{$altTitle|escape}">{$originalStyleFileName|escape}</a>
			{/if}
		{/fbvFormSection}
	{/fbvFormArea}
	<input type="hidden" name="temporaryFileId" id="temporaryFileId" value="" />

	{foreach from=$pubIdPlugins item=pubIdPlugin}
		{assign var=pubIdMetadataFile value=$pubIdPlugin->getPubIdMetadataFile()}
		{include file="$pubIdMetadataFile" pubObject=$issue}
	{/foreach}

	{call_hook name="Templates::Editor::Issues::IssueData::AdditionalMetadata"}

	{fbvFormButtons submitText="common.save"}
</form>