// Print today's timed Calendar.app events as "HH:mm - HH:mm", one per line, sorted.
// Declined and all-day events are skipped. Built by build.sh; used by calendar.30s.sh.
import EventKit
import Foundation

let store = EKEventStore()
let gate = DispatchSemaphore(value: 0)
var granted = false
store.requestFullAccessToEvents { ok, _ in
    granted = ok
    gate.signal()
}
gate.wait()
guard granted else {
    FileHandle.standardError.write(Data("calendar-events: calendar access denied\n".utf8))
    exit(1)
}

let calendar = Calendar.current
let dayStart = calendar.startOfDay(for: Date())
let dayEnd = calendar.date(byAdding: .day, value: 1, to: dayStart)!
let predicate = store.predicateForEvents(withStart: dayStart, end: dayEnd, calendars: nil)
let clock = DateFormatter()
clock.dateFormat = "HH:mm"

for event in store.events(matching: predicate).sorted(by: { $0.startDate < $1.startDate }) {
    if event.isAllDay { continue }
    if let me = event.attendees?.first(where: { $0.isCurrentUser }), me.participantStatus == .declined { continue }
    print("\(clock.string(from: event.startDate)) - \(clock.string(from: event.endDate))")
}
