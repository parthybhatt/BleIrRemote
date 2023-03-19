/********************************************************************************
* Filename    : 

* Author      : Parth Bhatt

* Date        : 

* Description : 

********************************************************************************/

/*******************************************************************************
* Include Files
********************************************************************************/
#include "circular_buffer.h"
#include <stdint.h>
#include <stdbool.h>
#include <string.h>

/*******************************************************************************
* Constants and macros
********************************************************************************/

/*******************************************************************************
* Data types (Structs, enum)
********************************************************************************/

/*******************************************************************************
* Static Variables
********************************************************************************/

/*******************************************************************************
* Static Functions Declaration
********************************************************************************/
void AddElementAtIndex(CircularBufferStruct_t* buffer, void* element);

/*******************************************************************************
* Public Functions
********************************************************************************/
void CircularBuffer_Init(CircularBufferStruct_t* bufferStruct, void* buffer, uint32_t numElems, uint32_t elementsize, bool overflow)
{
	bufferStruct->writerIdx = 0;
	bufferStruct->readerIdx = 0;
	bufferStruct->maxElems = numElems;
	bufferStruct->elementSize = elementsize;
	bufferStruct->bufferArray = buffer;
	bufferStruct->allowOverflow = overflow;
	bufferStruct->bufferState = BUFFER_STATE_EMPTY;
}

bool CircularBuffer_AddElement(CircularBufferStruct_t* buffer, void* element)
{
	bool status = true;
	if(buffer->bufferState == BUFFER_STATE_FULL)
	{
		if(buffer->allowOverflow == true)
		{
			buffer->readerIdx++;
			AddElementAtIndex(buffer, element);
		}
		else
		{
			status = false;
		}
	}
	else
	{
		AddElementAtIndex(buffer, element);
		if(buffer->bufferState == BUFFER_STATE_EMPTY)
		{
			buffer->bufferState = BUFFER_STATE_HAS_ELEMENTS;
		}
	}
	if(buffer->writerIdx == buffer->readerIdx)
	{
		buffer->bufferState = BUFFER_STATE_FULL;
	}
	return status;
}

bool CircularBuffer_GetLastElement(CircularBufferStruct_t* buffer, void* element)
{
	bool status = false;
	void* bufferLoc = buffer->bufferArray;

	bufferLoc += (buffer->readerIdx * buffer->elementSize);
	if(buffer->bufferState == BUFFER_STATE_EMPTY)
	{
		status = false;
	}
	else
	{
		memcpy(element, bufferLoc, buffer->elementSize);
		buffer->readerIdx++;
		if(buffer->readerIdx == buffer->maxElems)
		{
			buffer->readerIdx = 0;
		}
		if(buffer->readerIdx == buffer->writerIdx)
		{
			buffer->bufferState = BUFFER_STATE_EMPTY;
		}
		else if(buffer->bufferState == BUFFER_STATE_FULL)
		{
			buffer->bufferState = BUFFER_STATE_HAS_ELEMENTS;
		}
		status = true;
	}

	return status;
}

BufferState_t CircularBuffer_GetBufferState(CircularBufferStruct_t* buffer)
{
    return buffer->bufferState;
}

/*******************************************************************************
* Static Functions
********************************************************************************/

void AddElementAtIndex(CircularBufferStruct_t* buffer, void* element)
{
	void* bufferLoc = buffer->bufferArray;

	bufferLoc += (buffer->writerIdx * buffer->elementSize);
	memcpy(bufferLoc, element, buffer->elementSize);
	buffer->writerIdx++;
	if(buffer->writerIdx == buffer->maxElems)
	{
		buffer->writerIdx = 0;
	}
}
