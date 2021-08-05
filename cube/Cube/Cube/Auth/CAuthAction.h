/**
 * This file is part of Cube.
 *
 * The MIT License (MIT)
 *
 * Copyright (c) 2020-2022 Shixin Cube Team.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

#ifndef CAuthAction_h
#define CAuthAction_h

#ifndef CUBE_AUTH_APPLY_TOKEN
#define CUBE_AUTH_APPLY_TOKEN @"applyToken"
#endif

#ifndef CUBE_AUTH_SC_OK
#define CUBE_AUTH_SC_OK 0
#endif

#ifndef CUBE_AUTH_SC_FAILURE
#define CUBE_AUTH_SC_FAILURE 9
#endif

/*!
 * @brief 存储故障。
 */
#ifndef CUBE_AUTH_SC_STORAGE
#define CUBE_AUTH_SC_STORAGE 20
#endif

/*!
 * @brief 本地任务超时。
 */
#ifndef CUBE_AUTH_SC_TIMEOUT
#define CUBE_AUTH_SC_TIMEOUT 21
#endif

#endif /* CAuthAction_h */
