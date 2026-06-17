# Directive — mathlib-analogist `carrier-soundness-design`

## Mode

`api-alignment` (primary) with `cross-domain-inspiration` fallback
if no direct Mathlib precedent.

## Question

The project has 7+ load-bearing typed `:= sorry` definition carriers
(diagnosed by lean-auditor iter-193) at:

- `AlgebraicJacobian/Picard/RelPicFunctor.lean` — `PicSharp := sorry`,
  `presheaf := sorry`, `PicSharp.etSheaf := sorry`.
- `AlgebraicJacobian/Picard/QuotScheme.lean` — `QuotScheme := sorry`
  (L326-area).
- `AlgebraicJacobian/Picard/Pic0AbelianVariety.lean` — `Pic0Scheme :=
  sorry`, `PicScheme := sorry`.
- Additional: `picSharp`, `divFunctor`, `abelMap` (per lean-auditor).

These `:= sorry` decls participate in typeclass synthesis (e.g.,
downstream lemmas resolve `[AddCommGroup Pic0Scheme]` which transitively
depends on the `Pic0Scheme := sorry` body). The result is **silent
`sorryAx` propagation** through typeclass synthesis — the consumer
proofs appear sorry-free at the source level but their kernel terms
depend on `sorryAx`. The project's stated end-state requires
kernel-only axioms (`propext`, `Classical.choice`, `Quot.sound`); so
this must be refactored before the protected declarations
`AlgebraicGeometry.Jacobian` etc. can pass `lean_verify`.

## Three design options the planner is considering

The plan agent has identified three carrier-shape options for the
refactor `pic-quot-relpic-carrier-soundness`:

**Option A — Existential `Nonempty (Σ' S, <props>)`**

```lean
def Pic0Scheme (C : Curve k) : Type :=
  -- Bundle Pic0Scheme as the choice from an existence claim:
  Classical.choose (existence_claim_for_Pic0Scheme C)
-- where existence_claim_for_Pic0Scheme C : ∃ S : Type, <properties>
-- ⟹ NO `sorry`; the existence proof is a separate typed sorry.
```

**Option B — Opaque axiom (a clean axiom Pic0Scheme + axiom-clean
property bundle)**

```lean
opaque Pic0Scheme (C : Curve k) : Type
opaque Pic0Scheme.isAbelianVariety : IsAbelianVariety (Pic0Scheme C)
-- ⟹ NO `sorry`; the axiom is the load-bearing entity.
```

**Option C — Structure-of-data carrying both type and properties**

```lean
structure Pic0Scheme.Data (C : Curve k) where
  carrier : Type
  abelianVariety : IsAbelianVariety carrier
-- and `def Pic0Scheme (C : Curve k) : Pic0Scheme.Data C := sorry`
-- — but the `sorry` is now Mathlib-side data construction, not a
-- type definition.
```

## What I want from you

1. **Mathlib precedent**: which Mathlib decls solve the same pattern
   ("we know X exists with properties P, but the existence proof is
   itself the work; we want downstream lemmas to consume X NOW
   without inheriting sorries through typeclass synthesis")? Search
   in particular:
   - `Mathlib.Geometry.Manifold` — manifold-of-* constructions.
   - `Mathlib.Topology.Sheaves` — sheafification carriers.
   - `Mathlib.CategoryTheory.Limits` — colimit carriers.
   - `Mathlib.RingTheory.Localization` — localisation carriers.
   - Constructions tagged `opaque` vs `def := sorry` patterns.
2. **Verdict on Option A vs B vs C**:
   - Which is the Mathlib idiom? Often `Nonempty` claims (Option A)
     vs `opaque` (Option B) vs `structure` (Option C) make different
     trade-offs (computability, typeclass synthesis, downstream
     consumer ergonomics).
   - Specifically — does Mathlib prefer **A** for "existence-via-choice"
     constructions? Is **B** used for genuinely Mathlib-axiomatic
     constructions (universe issues, large cardinals)? Is **C** the
     right pattern when the carrier needs to expose multiple
     auxiliary data?
3. **Practical concern**: which option allows downstream lemmas to
   pass `lean_verify` with kernel-only axioms once the existence
   proof itself is closed? In particular, does Option A (Classical
   choice) violate the kernel-only constraint? (`Classical.choose` is
   `Classical.choice` which IS a kernel axiom, so Option A may be OK
   — verify.)
4. **Effort estimate**: rough LOC + iter cost for the carrier-
   soundness refactor under each option. The plan agent currently
   estimates 2-4 iters under any option; sharpen this.

## Iter-194 plan-phase committed iter-200 slot

STRATEGY.md currently commits the carrier-soundness refactor to
iter-200, co-scheduled with the mandatory mathlib-analogist sweep.
The iter-195 strategy-critic CHALLENGEd this slot, recommending the
plan-phase fire this directed consult THIS iter and pull the
refactor forward to iter-196.

This directive IS that pull-forward consult. The plan agent will use
your verdict to decide between:
- **(i)** keep refactor at iter-200 (if you confirm the design analysis
  needs the full mathlib-analogist sweep context), or
- **(ii)** pull refactor to iter-196 (if you give a concrete Option
  verdict THIS iter), or
- **(iii)** iter-198 / iter-199 compromise (if the verdict is partial).

## What you should NOT do

- Do NOT make the refactor itself; this is design analysis only.
- Do NOT mark anything as `\leanok` / `\mathlibok` in any file.
- Do NOT recommend "wait for upstream Mathlib decision" — the question
  is which of A/B/C is the right Mathlib idiom for this pattern, not
  whether Mathlib needs new infrastructure.

## Files to read

- `AlgebraicJacobian/Picard/RelPicFunctor.lean` — the
  `PicSharp / presheaf / PicSharp.etSheaf` carriers.
- `AlgebraicJacobian/Picard/QuotScheme.lean:326-area` — `QuotScheme :=
  sorry`.
- `AlgebraicJacobian/Picard/Pic0AbelianVariety.lean` — `Pic0Scheme :=
  sorry`, `PicScheme := sorry`.
- The current `.archon/STRATEGY.md` for the iter-200 commitment text.

## Output

Standard `analogies/carrier-soundness-design.md` + task_results
report. The plan agent will use the analogies file to update
STRATEGY.md iter-196 plan-phase with the chosen Option + concrete
iter slot.
