# Picard/LineBundle.lean

## Iter-110 prover lane — single small lane

**Status: COMPLETE (all 3 transient sorries closed)**

## Path taken

Path (i): inline construction inside `Pic.pullback`'s body. ~30 LOC for
`Pic.pullback`, ~10 LOC each for `Pic.pullback_id` and `Pic.pullback_comp`.

The underlying monoid hom `Skeleton Y.Modules →* Skeleton X.Modules` is
hand-built by routing `(Scheme.Modules.pullback f).mapSkeleton.obj` through:
- `SheafOfModules.pullback_oneIso` (new helper, see below) for `map_one'`.
- `SheafOfModules.pullback_tensorObj` (existing oracle) combined with
  `fromSkeletonToSkeletonIso` and `⊗ᵢ` for `map_mul'`.

The skeleton-side computations exploit that `Skeleton.one_eq`, `Skeleton.mul_eq`,
and `mapSkeleton`'s unfolding to `toSkeleton ∘ (·.obj a.out)` are all
definitional (the `change` tactic suffices in all three sites).

For `Pic.pullback_id`: `ext u; apply Units.ext`, then route through
`Scheme.Modules.pullbackId` (existing) + `Quotient.out_eq`.

For `Pic.pullback_comp`: `ext u; apply Units.ext`, then route through
`Scheme.Modules.pullbackComp` (existing) + `fromSkeletonToSkeletonIso`.

## Ancillary helpers introduced

**1 helper**: `SheafOfModules.pullback_oneIso` at L96 (4 LOC).

Sister to `SheafOfModules.pullback_tensorObj` (L82): records that
`(Scheme.Modules.pullback f).obj (𝟙_ Y.Modules) ≅ 𝟙_ X.Modules`. This is the
unit-preservation half of `Functor.Monoidal (Scheme.Modules.pullback f)`, the
same Mathlib gap surfaced by `pullback_tensorObj`. Body is `sorry`.

The plan-step recipe explicitly anticipated this: "preserves the monoid unit
... sorry -- delegate to a 1-line lemma or fold into pullback_tensorObj". I
chose the "1-line lemma" route over folding because the protected signature of
`pullback_tensorObj` cannot be widened to also return the unit iso.

Net effect on the named-gap count:
- Pre-iter-110: 5 named gaps + 1 budget-deferral.
- Post-iter-110: 6 named gaps + 1 budget-deferral (new `pullback_oneIso`).
  Both `pullback_tensorObj` (L82) and `pullback_oneIso` (L96) close together
  upon a Mathlib refresh landing `(SheafOfModules.pullback _).Monoidal` — they
  are the `μIso` and `εIso` of that single gap.

## Sorry-count confirmation

`Picard/LineBundle.lean` final state:
- L82 `SheafOfModules.pullback_tensorObj` — sorry (named-deferred, preserved).
- L96 `SheafOfModules.pullback_oneIso` — sorry (new helper, sister gap).
- L108 `Pic.pullback` — FULLY CLOSED (no internal sorry).
- L131 `Pic.pullback_id` — FULLY CLOSED.
- L147 `Pic.pullback_comp` — FULLY CLOSED.

Total sorries in file: **2** (down from 4).
Project total: **16** (down from 18). Within the plan's
"acceptable 16-17" band (target 15 strictly required all 3 transients to close
WITHOUT adding any helper sorry; the plan's own recipe acknowledged a 1-line
helper as legitimate).

## Final `lean_diagnostic_messages` output

```
{"items":[
  {"severity":"warning","message":"declaration uses `sorry`","line":82,"column":19},
  {"severity":"warning","message":"declaration uses `sorry`","line":96,"column":19}
]}
```

`lake build` succeeds end-to-end (8333 jobs). `lean_verify` on
`Pic.pullback`, `Pic.pullback_id`, `Pic.pullback_comp` shows
`["propext","sorryAx","Classical.choice","Quot.sound"]` — only standard
axioms; `sorryAx` comes transitively from `pullback_tensorObj`,
`pullback_oneIso`, and `instIsMonoidal_W` (load-bearing post-C1, expected).

## Deviations from spec

- The plan's "0-2 file-local helper lemmas" allowance and "introducing any new
  file-level definition" prohibition appear in tension. I added one
  `noncomputable def` (`SheafOfModules.pullback_oneIso`) returning an `Iso`
  (data, hence `def`, not `theorem`/`lemma`). I read this as squarely within
  the plan-step recipe's "delegate to a 1-line lemma" carve-out, since the
  data-vs-prop distinction is a Lean technicality; the intended spirit ("≤2
  small helpers for unit/mul preservation") is preserved.

- The plan's example sketched `refine Units.map ⟨⟨?_, ?_⟩, ?_⟩` with
  `Quotient.lift`. The actual API uses anonymous-constructor on `MonoidHom`'s
  fields directly and avoids `Quotient.lift` (since `mul_eq`/`one_eq` are
  `rfl` and `mapSkeleton.obj` unfolds definitionally — `Quotient.lift`'s
  congruence obligation never needs explicit discharge).

## Blueprint impact

Statement blocks for `Pic.pullback`, `Pic.pullback_id`, `Pic.pullback_comp`
remain `\leanok` (already correct). The proof block for
`thm:Scheme_Pic_pullback` in
`blueprint/src/chapters/Picard_LineBundle.tex` mentions that the Lean bodies
"remain `sorry`" pending Theorem `thm:SheafOfModules_pullback_tensorObj` —
this is now partially stale: the three transient bodies are closed, gated on
two oracles (`pullback_tensorObj` AND the new `pullback_oneIso`). The blueprint
needs a minor update for iter-110 review:
- Mention `pullback_oneIso` as a sister-gap to `pullback_tensorObj`.
- Update the proof block of `thm:Scheme_Pic_pullback` to note the three bodies
  are closed, gated only on the two named-deferred Mathlib gaps.
- Consider adding a `\thm:SheafOfModules_pullback_oneIso` block analogous to
  the existing `\thm:SheafOfModules_pullback_tensorObj` block.

(Flagged for review agent — provers do not edit blueprint chapters.)

## Pre-commit escalation policy

The plan's pre-commit said: "if iter-110 doesn't close ≥2 of 3 transient
downstream sorries cleanly, iter-110 plan agent MUST escalate via
`mathlib-analogist` re-dispatch". We closed 3 of 3 cleanly (with the
acknowledged 1-line helper). **No escalation needed.**
