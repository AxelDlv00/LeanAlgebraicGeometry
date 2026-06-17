# blueprint-writer directive — Cohomology_FlatBaseChange.tex (FBC diamond mechanism + gstar fix)

## Chapter
`blueprint/src/chapters/Cohomology_FlatBaseChange.tex`

## Why this dispatch
The iter-028 lean-vs-blueprint check flagged TWO must-fix blueprint-adequacy failures on this chapter
(both block the FBC prover under the HARD GATE). A mathlib-analogist consult (iter-029) has now produced
the concrete term-mode mechanism that resolves the underlying `X.Modules` instance diamond. Fold that
mechanism into the chapter and fix the two flagged proof sketches.

## Required edits

### 1. `lem:base_change_mate_inner_eCancel_assemble` — document the diamond + the term-mode mechanism (MUST-FIX §1)

The current proof sketch ("apply the three one-cancellation atoms in turn") is mathematically correct
but gives a prover NO actionable path: the `X.Modules` `CategoryStruct.comp`/`Functor.map` instance
diamond defeats all keyed rewriting. Add to this block's proof prose (and a `% NOTE:` comment) the
**mechanism**, stated mathematically (NO Lean tactic strings in the rendered prose — keep tactic names
to a `% NOTE:` comment), drawn from `analogies/fbc-functorimage-diamond.md` and the analogist report
`.archon/task_results/mathlib-analogist-fbc-diamond.md`:

- The obstruction: after distributing `Functor.map` over the composite, the factor to collapse sits
  over the **nested-`obj`** object `G.obj (H.obj M)` while the collapse lemma fixes the **composed-`⋙`**
  object `(H ⋙ G).obj M`; these are definitionally but not syntactically equal, so keyed rewriting
  cannot abstract the motive and a defeq-tolerant rewrite exceeds the reduction budget on the large
  concrete leg.
- The resolution: single-factor surgery is done in **term mode** — lift each factor-equation into the
  composite by congruence on one neighbour at a time and chain the steps, closing on the definitional
  bridge; the object-form/associativity diamond is absorbed at that final closing step (the move keyed
  rewriting structurally cannot make). The three eCancel atoms are **already shipped and already in the
  goal's `Γ∘(Spec φ)_*` form** — they are spliced directly (the earlier `hpfc`/bare-`gammaMap` route is
  abandoned). The lone survivor is the affine `(Spec ιA)`-unit, evaluated by Seam 1 to `ρ`.
- `% NOTE:` comment may name the Lean idiom for the prover: `congrArg (· ≫ _)` / `congrArg (_ ≫ ·)` /
  `Functor.congr_map`, `.trans`-chained, `exact`-closed; three compiling in-file precedents
  (`pullbackPushforward_unit_comp`, `..._gammaDistribute`, `base_change_mate_inner_eCancel_pushforwardComp`).

### 2. `lem:base_change_mate_gstar_transpose` — fix step-3 dependency claim (MUST-FIX §2)

The current step-3 cites `lem:base_change_mate_inner_value_eq` as established, but that lemma is
sorry-backed via `_legs`. Correct the sketch to state: step 3 (Seam-A inner value) currently routes
THROUGH the leg-parametrised reindex (`lem:base_change_mate_fstar_reindex_legs`), which carries the same
`_legs` eCancel obligation as in §1; once that obligation is discharged by the term-mode mechanism, the
inner value is available and `gstar_transpose` cites it directly. `gstar_transpose`'s own assembly uses
the SAME term-mode mechanism for its conjugate-counit factor (the analogist confirms the mechanism ports
to `gstar_transpose` identically). Make the `\uses{}` reflect the real dependency on
`lem:base_change_mate_fstar_reindex_legs` / `lem:base_change_mate_inner_eCancel_assemble`.

### 3. Coverage / cleanup (from the iter-028 lvb report §4/§5, non-blocking but do while here)
- `lem:base_change_regroup_linearEquiv` appears in `\uses{}` of `lem:base_change_mate_regroupEquiv` but
  has no `\lean{}` and no Lean decl (the content is folded into `base_change_mate_regroupEquiv`). Remove
  it from that `\uses{}` (it is a phantom).
- The three `private` atoms (`gammaMap_pushforwardComp_hom_eq_id`, `..._inv_eq_id`,
  `gammaMap_pushforwardCongr_hom`) are pinned by public-form `\lean{}`. Leave a `% NOTE:` that these are
  `private` in Lean (mangled names) so the pin-resolution mismatch is documented; do NOT change the
  pins. (De-privatizing is a prover-side action, out of scope for you.)

## Out of scope
- Do NOT add or remove `\leanok` (sync_leanok owns it).
- Do NOT touch the affine `@1995` / FBC-B `@2017` blocks (still genuinely open, separate phase).
- Do NOT rewrite sorry-free helper blocks that the lvb report marked ✓.

## References
Source for the base-change statement is Stacks 02KH part 2 (already cited in-chapter). The mechanism is a
formalization technique, not new mathematics — no new reference needed. `references/**` is in your write
domain only in case you find a citation genuinely missing; do not invent one.
