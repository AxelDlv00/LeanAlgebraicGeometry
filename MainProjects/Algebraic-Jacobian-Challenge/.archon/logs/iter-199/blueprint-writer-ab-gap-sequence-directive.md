# Blueprint writer directive — iter-199 (slug: `ab-gap-sequence`)

## Target chapter

`blueprint/src/chapters/Albanese_AuslanderBuchsbaum.tex` ONLY.

## Why now (progress-critic STUCK verdict on Lane AB)

The progress-critic `route199` returned a **STUCK** verdict on
Lane AB (`AuslanderBuchsbaum.lean` L1299 / `auslander_buchsbaum_formula_succ_pd`):

> The CHURNING rule also fires (helpers in ≥2 iters, sorry net
> unchanged). Picking the worse verdict: STUCK.
> 
> Primary corrective: Blueprint expansion. The 3-gap dependency
> chain (gaps 1, 2, 3) means L1299 cannot close until all three
> are discharged. Gap (4) is done. The blueprint chapter must be
> expanded to show explicit per-gap estimates and the sequencing
> constraint (whether gaps 2 and 3 can be parallelized or must
> follow gap 1).

The iter-199 plan agent dispatches you to expand the AB chapter's
sub-gap section with **explicit per-gap LOC estimates and the
gap (1) → gap (3) sequencing constraint** so that the iter-200+
planner has a structured decomposition to draw the next prover
target from.

## Strategy context

`auslander_buchsbaum_formula_succ_pd` (n=k+1 inductive step) closes
once 4 substrate pieces land. As of iter-198:

- **Gap (1)** `lemma-add-trivial-complex` (minimal-resolution
  carving) — Stacks 00LK / Bruns-Herzog §1.5 — STATUS: absent at
  Mathlib b80f227. **iter-199 prover target** (Lane AB-gap1).
  Estimated 80-120 LOC (Bruns-Herzog Construction 1.5.18 +
  minimal-resolution induction). Independent of gaps (2) and (3).
- **Gap (2)** `proposition-what-exact` (Stacks 00MF, "what is
  exact" criterion characterising exactness in terms of depths of
  r-minors) — STATUS: absent at Mathlib b80f227. Estimated
  ~150-200 LOC (Bruns-Herzog Theorem 1.4.13 chain; Eagon-Northcott
  / Buchsbaum-Eisenbud). **Largest gap**; candidate for Mathlib
  upstream PR. Independent of gaps (1) and (3) at the bottom of
  the dependency graph (it provides
  `depth ≥ e ⟹ resolution length ≤ e`).
- **Gap (3)** Snake-lemma-on-minimal-resolution — preserves
  projective dimension under tensoring by `R/(x)` for an `M`-regular
  `x ∈ 𝔪`. STATUS: absent at Mathlib b80f227. Estimated
  ~80-120 LOC. **Depends on gap (1)** — the snake-lemma needs the
  minimal-resolution structure to assert the resulting tensor-
  resolution remains minimal of the same length.
- **Gap (4)** `lemma-depth-drops-by-one` — STATUS: **closed**
  iter-198 axiom-clean
  (`depth_quotSMulTop_succ_eq_depth_of_isSMulRegular`).

## Required edits

### 1. Add a new subsection `subsec:succ_pd_gap_sequence` immediately after the existing inductive-step lemma block (`lem:auslander_buchsbaum_formula_succ_pd`)

The subsection should contain:

- A short prose intro stating the 3-remaining-gap structure (1, 2,
  3) and the sequencing constraint (gap (3) requires gap (1);
  gaps (1) and (2) are independent at the substrate level).
- A dependency diagram (LaTeX `tikzpicture` or a plain text
  ASCII-style diagram) showing:
  ```
  gap (1) — minimal-resolution carving
      |
      ↓
  gap (3) — snake-lemma-on-min-resolution
      |
      ↓
  L1299 — close auslander_buchsbaum_formula_succ_pd
      ↑
      |
  gap (2) — Stacks 00MF "what is exact"
  ```
  (Gap (2) feeds the body assembly independently of gap (1)→gap (3).)
- A table or per-gap block giving:
  | Gap | LOC est | Iters est | Mathlib status | Dependencies |
  | (1) | 80-120 | 1-2 | absent | none |
  | (2) | 150-200 | 2-3 | absent | none |
  | (3) | 80-120 | 1-2 | absent | gap (1) |
- A "Closure assembly" paragraph stating that once gaps (1) +
  (3) AND gap (2) all land axiom-clean, the body of L1299 closes
  in ~80-120 LOC of assembly (snake-lemma application on minimal
  resolution; depth-drops-by-one applied twice using gap (4) helper;
  inductive hypothesis on `(R/(x), M/xM)`).
- An iter-budget estimate: gap (1)=1-2 iters + gap (2)=2-3 iters +
  gap (3)=1-2 iters + closure assembly=1 iter = **5-8 iters total
  remaining** for L1299. This refines (and may widen) the
  STRATEGY.md "~6-12 iters" estimate from iter-195; the iter-199
  plan agent will incorporate the refinement.

### 2. Update the stale block-internal references

The existing chapter prose (proof block of `thm:auslander_buchsbaum`
inductive step, L388-L412 area) references "Lemma REF" placeholders
for gap (2). Refresh these to point at the new
`subsec:succ_pd_gap_sequence` block by name (e.g.
`\cref{subsec:succ_pd_gap_sequence}`).

### 3. (Optional) Cross-reference the existing helpers

The two iter-198 closures (`lem:depth_drops_by_one` and the
companion regular-element-existence helper) are pinned in the
chapter as of iter-199 (added by the plan agent). The new
subsection can `\cref{}` them to make the gap (4) → CLOSED
status visible alongside gaps (1)-(3) ABSENT.

## Out-of-scope

- Do NOT modify `\leanok` or `\mathlibok` markers anywhere.
- Do NOT touch the existing `lem:auslander_buchsbaum_formula_succ_pd`
  block, `lem:depth_drops_by_one` block, or the main
  `thm:auslander_buchsbaum` theorem block. Append the new
  subsection AFTER the existing material.
- Do NOT speculate beyond what's listed above — the gap (3) details
  + Stacks 00MF assembly logic should be left at the level of "what
  is needed; iter-N+ targets" without speculative Lean API hints.

## References available locally

- `references/stacks-algebra.md` → `references/stacks-algebra.tex`
  for Stacks 00LK, 00MF, 090V.
- Bruns-Herzog "Cohen-Macaulay Rings" §1.4-§1.5 — verify whether
  a local copy exists under `references/bruns-herzog.pdf`; if not,
  cite by chapter/section only.

## Verification

After landing, re-read the chapter to confirm:
- New `subsec:succ_pd_gap_sequence` exists and contains the 3
  required components (dependency diagram, per-gap table, closure
  assembly paragraph).
- Existing material untouched.
- No new typos or LaTeX errors.

Report back: line ranges of new content; total LOC added; any
unanticipated findings.
