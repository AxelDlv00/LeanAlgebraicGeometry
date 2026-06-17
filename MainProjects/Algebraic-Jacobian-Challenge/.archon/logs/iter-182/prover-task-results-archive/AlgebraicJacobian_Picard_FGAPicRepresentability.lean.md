# AlgebraicJacobian/Picard/FGAPicRepresentability.lean

## Iter-182 outcome: DEFERRAL RESPECTED — no edits

### Status

- **File state entering iter-182**: 7 typed `sorry`s (file-skeleton from
  iter-176 Lane I); 0 axioms; `lake build` GREEN.
- **File state exiting iter-182**: identical (no edits this iter).
- **Diagnostic check (LSP)**: 0 errors; 7 sorry-warnings at
  L132 / L147 / L187 / L226 / L278 / L324 / L363 — matches expectation.

### Why no edits

This file is explicitly listed both in `PROGRESS.md` and in
`task_pending.md` as a **standing deferral (iter-190+)** and appears in
the iter-182 **"Off-limits this iteration"** block:

> `Picard/{FlatteningStratification, FGAPicRepresentability, RelPicFunctor}.lean` body — standing deferrals.

And:

> `Picard/FGAPicRepresentability.lean` — **7 sorries** file-skeleton.
> **Standing deferral**: iter-190+.

Iter-182's active prover lanes are A, B, D, E, F, G, I, none of which
target this file. It was assigned this iter without an active
objective — interpreting the deferral correctly is the right move.

### Why substantive progress is structurally impossible from inside this file alone

The 5 pinned substantive declarations (`PicScheme`, `abelMap`,
`smoothProperQuotient`, `representable`, `groupSchemeStructure`) are
all downstream of the two file-internal placeholders `picSharp` and
`divFunctor` (L132 / L147). Those placeholders are typed `sorry`
*carriers* deliberately kept local until the sibling chapters land
their own pinned defs (per the file header §0 prose).

- **`picSharp` → sibling `AlgebraicGeometry.Scheme.PicSharp` (sibling chapter `Picard/RelPicFunctor.lean`, A.1.c)** —
  Verified: `RelPicFunctor.lean:284` defines `PicSharp` with body
  `:= sorry`. It also has an *incompatible signature* with the local
  carrier:
  - local `picSharp`: `(_C : Over (Spec (.of k))) → (Over (Spec (.of k)))ᵒᵖ ⥤ Type u`
  - sibling `PicSharp`: `(_C : Over (Spec (.of k))) [SmoothOfRelativeDimension 1 _C.hom] [IsProper _C.hom] → (Over (Spec (.of k)))ᵒᵖ ⥤ AddCommGrpCat.{u+1}`

  Different value category (`Type u` vs `AddCommGrpCat.{u+1}`) and
  additional typeclass arguments. Converting `picSharp` to a re-export
  would require a coordinated signature refactor across this file's
  5 downstream declarations — out of scope for prover phase and
  squarely a plan-phase concern (cross-file signature alignment).

  `RelPicFunctor.lean` is itself a **standing deferral (iter-184+)**
  (per `PROGRESS.md` line 53 / `task_pending.md` line 52-53).

- **`divFunctor` → sibling `Picard/QuotScheme.lean` divisor functor** —
  `QuotScheme.lean` is the **iter-182 Lane F PIVOT** target but the
  active work there is a typed-sorry def addition for
  `Scheme.Modules.pullback_app_isoTensor`, not the divisor functor
  pin. The pin will land downstream of the Quot/Hilbert engine body
  (Kleiman §3 Thm. `th:repDiv`), gated on the deeper Quot machinery.

Without sibling `PicSharp` / `divFunctor` having landed at compatible
types, the only "edits" available inside this file are cosmetic
(docstring tweaks). The prover prompt's "Never weaken the type to dodge
the proof" rule explicitly bans the alternative move (replacing the
typed-sorry carriers with constant functors or `Iso.refl`-style
placeholders), and the file's iter-176 docstring already commits to the
intended substantive types via the `\lean{...}` blueprint pin.

### No journal entries needed

Per the prover-prover prompt's logging spec, each section is "one section
per theorem/lemma in your file" with attempt history. **No attempts
were made this iter** because the deferral is correct and any attempt
would either (i) propagate `sorry` through carriers (no actual progress)
or (ii) violate the file-ownership rule by editing sibling files.

### Next-iter notes

iter-183 plan-phase should NOT pick this file as a prover target unless:

1. `Picard/RelPicFunctor.lean` has landed `AlgebraicGeometry.Scheme.PicSharp`
   with a non-`sorry` body and a stable signature, AND
2. `Picard/QuotScheme.lean` has landed the `divFunctor` pin with a stable
   signature, AND
3. A signature-alignment refactor lands FIRST that makes the local
   `picSharp` / `divFunctor` carriers compatible re-exports of the
   sibling pins (this is a plan-phase / refactor-subagent job, not a
   prover job — likely needs `refactor fgapic-sig-align` or similar).

When all three preconditions hold, the file-internal carriers collapse
to one-line `:= AlgebraicGeometry.Scheme.PicSharp _` / `... divFunctor _`
re-exports and the 5 pinned declarations gain body content via the
Kleiman §4 Thm. `th:main` 4-step proof.

### Dead-end documentation

- **Replacing `picSharp` / `divFunctor` with constant functors** —
  banned by "Never weaken the type to dodge the proof"; the 5
  downstream pins would gain trivially-true type signatures.
- **Inlining the entire `PicSharp` body here** — banned by
  file-ownership rule (`Picard/RelPicFunctor.lean` is a different
  agent's file).
- **Forward-importing `Picard/RelPicFunctor` symbols** — `picSharp`'s
  current return type (`Type u`) is structurally incompatible with
  `PicSharp`'s (`AddCommGrpCat.{u+1}`); even importing wouldn't yield
  a working re-export without first refactoring the *consumer* signature
  in this file.

### File-specific user hints (`/- USER: ... -/`)

None present in the file.

### Blueprint marker handoff

No new `\leanok` candidates; no semantic-marker requests for the review
agent. The 7 pinned declarations remain unformalized per blueprint
status.
