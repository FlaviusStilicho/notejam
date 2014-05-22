@extends('user')

@section('page_title')
Delete note {{ $note->name }}
@stop

@section('content')
    {{ Form::open() }}
    <p>Are you sure you want to delete {{ $note->name }}?</p>
    {{ Form::submit('Yes, I want to delete this note', array('class' => 'button red')) }}
    <a href="{{ URL::route('view_note', array('id' => $note->id))}}">Cancel</a>

    {{ Form::close() }}
@stop

