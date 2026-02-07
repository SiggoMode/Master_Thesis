#ifndef ThreadSafeValue_HPP
#define ThreadSafeValue_HPP

#include <mutex>

template <typename T>
class ThreadSafeValue{
public:
    ThreadSafeValue() : data_(), hasNewValue_(false) {}

    ThreadSafeValue(T data) : data_(std::move(data)), hasNewValue_(true) {}

    void set(T data) {
        std::lock_guard<std::mutex> lock(m_);
        data_ = std::move(data);
        hasNewValue_ = true;
    }

    T take () {
        std::lock_guard<std::mutex>  lock(m_);
        hasNewValue_ = false;
        return data_;
    }

    bool hasNewValue() {
        std::lock_guard<std::mutex> lock(m_);
        return hasNewValue_;
    };

private:
    T data_;
    std::mutex m_;
    bool hasNewValue_;
};

#endif