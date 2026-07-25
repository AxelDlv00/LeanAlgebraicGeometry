# Historical Design Notes

This directory preserves exploratory comparisons, API surveys, and route
decisions from earlier formalization campaigns. It is supporting history, not
the current project plan or mathematical blueprint. Some notes refer to old
iteration numbers, declarations, or file layouts and should be checked against
the current tree before reuse.

For current state, use:

- `horizon roadmap list --focus AJC.jacobian` for the proof and maintenance plan;
- `horizon inbox list --project Algebraic-Jacobian-Challenge` for open issues and
  durable failure memory;
- `horizon graph -p Algebraic-Jacobian-Challenge frontier` for declaration-level
  dependencies and the formalization frontier.

The filenames are searchable by topic: `cech` and `fbc` cover cohomology and
flat base change; `pic`, `quot`, and `tensor` cover Picard representability; and
`rigidity`, `cotangent`, and `differential` cover the Picard identity component.
New status reports and dead ends belong in the roadmap, inbox, or graph comments
rather than as additional iteration-numbered files here.
