# Analogy: re-keying a `MonoidalCategory` instance across a defeq-but-not-syntactic base carrier

## Mode
cross-domain-inspiration

## Slug
recon023

## Iteration
023

## Structural problem (abstracted)
A bundled typeclass instance `Inst (key)` is keyed on the **syntactic head** of `key`. The same
mathematical object appears in two spellings `k₁, k₂` that are **definitionally equal but have
different head symbols**. The global instance is keyed on `k₁`; one needs the instance (and lemmas
about it) available while the term is spelled `k₂`. Instance/`simp`/`rw` resolution is syntactic
(up to *reducible* transparency only), so it fails on `k₂`; the **kernel** checks full defeq, so a
finished `Prop` still closes across the wall. Question: how does Mathlib stop two defeq spellings
from racing over instance resolution, and what is the kernel-accepted way to expose / cross the
instance on the alternate carrier?

## Concrete instance of the problem
- Global instance `PresheafOfModules.monoidalCategory` is keyed on **`R.comp (forget₂ CommRingCat
  RingCat)`** with `R : Cᵒᵖ ⥤ CommRingCat` (verified via loogle; module
  `Mathlib.Algebra.Category.ModuleCat.Presheaf.Monoidal`). It fires iff the base presheaf-of-rings
  is *syntactically* `_ ⋙ forget₂ …`.
- `pullback φ'` / `adj` are over `X.presheaf ⋙ forget₂ …` → head is `Functor.comp` → **matches**,
  instance fires.
- `pushforward β` / `hadj` are over `X.ringCatSheaf.obj` → head is `Scheme.ringCatSheaf` → defeq to
  `X.presheaf ⋙ forget₂ …` but **not syntactic** → instance does NOT synthesize.
- The project ALREADY solves the identical mismatch for the ring-map `β` itself:
  `TensorObjSubstrate.lean:4174` `let β' : (Y.presheaf ⋙ forget₂ …) ⟶ … := β` — a pure defeq
  re-ascription onto the canonical carrier (this compiles; file is GREEN). The remaining failure is
  that `hadj`, `H1`, `μIsoβ` were NOT likewise re-ascribed, so the `IsMonoidal`/`μ_natural` step
  still drags the `ringCatSheaf.obj` carrier into the same term.

## Failed approaches (from directive)
- `inferInstanceAs` carrier cast → eta-expands into compiled noncomputable aux-defs (errors).
- direct-constant `letI (monoidalCategory (R := X.presheaf))` → `have`s elaborate but
  `μ_natural`/`IsMonoidal` fail (good-form vs letI-form not syntactically equal).
- explicit `…monoidalCategoryStruct` letIs → no effect; `haveI` → breaks `monβ` defeq;
  `noncomputable lemma` → rejected; `Functor.Monoidal.transport` → carrier non-synthesizable.

## Analogues found (ranked by porting cost)

### Analogue 1 — Type-synonym / canonical-carrier discipline + kernel-defeq `exact`
**Domain:** order theory · algebra · analysis (cross-cutting Lean engineering idiom).
**Citations (discipline precedents):**
- `OrderDual α` — `Mathlib.Order.Synonym` (reducible synonym of `α` carrying the *flipped* order;
  all crossings go through the defeq equiv `toDual`/`ofDual`, never through instance racing).
- `Multiplicative`/`Additive` — `Mathlib.Algebra.Group.TypeTags` (same: synonym + `ofAdd`/`toAdd`).
- `WithLp p V` — `Mathlib.Analysis.Normed.Lp.WithLp` (reducibly `V`, different norm instance;
  bridge is the defeq `WithLp.equiv`).
- `ModuleCat.restrictScalars f` — built so a *different* module instance is carried than the one
  that would synthesize on the underlying type.
- **In-project precedent (decisive):** `TensorObjSubstrate.lean:4174` (`β'` re-ascription) AND the
  D3′ technique recorded in STRATEGY "Completed": *"generic single-`[Category C]` lemmas applied by
  `exact` cross the `SheafOfModules`↔`Scheme.Modules` defeq-but-not-syntactic instance wall
  (`comp_cancel_mid` family)."*

**Same structural problem there:** Mathlib NEVER lets two defeq spellings of a type compete for
instance synthesis. It pins ONE canonical syntactic carrier, attaches the instance there, and moves
every term onto that carrier by a defeq re-ascription / defeq-equiv at the **term** level. Anything
that must cross the wall does so as a finished `Prop`, where the **kernel** (full defeq, unlike the
reducible-only elaborator) discharges it via a bare `exact`/`convert`.

**Technique:** (a) **Normalize the carrier.** Re-ascribe the off-carrier geometric terms onto the
`_ ⋙ forget₂` spelling, exactly as `β'` already does:
`let hadj' : PresheafOfModules.pushforward β' ⊣ PresheafOfModules.pushforward φ' := hadj`,
`let H1' : pushforward β' ≅ pullback φ' := H1`, `let μIsoβ' … := μIsoβ`. Because every RHS is defeq
to its LHS type, the ascriptions typecheck, and now the **only** `MonoidalCategory` carrier any
subterm mentions is `_ ⋙ forget₂ …`, so the global instance is the unique one in play — no diamond,
no `letI`. Build `hadj'.IsMonoidal` and run the entire recon022 mate calculus (`μ_natural`,
`unit_app_tensor_comp_map_δ`, `μIso_inv`) on this single carrier. (b) **Cross once, at the end.** The
residual `hcompat` goal `δ (pullback φ') M.val N.val = e.hom` is a `Prop` about morphisms; close it
with `exact <the δ-equation proved on the `_ ⋙ forget₂` carrier>` (or `convert … using 0` / `Eq.mpr`)
— the kernel checks the carrier defeq, which the elaborator refused to.

**Mapping to project:** objects = `hadj`, `H1`, `μIsoβ` at `TensorObjSubstrate.lean:4162/4167/4179`;
the re-ascription template is the existing `β'` at `:4174`. The Prop-cross at the very end is the
D3′ `exact`-across-the-wall move the project already used for `comp_cancel_mid`.
**Porting cost: LOW.** No new top-level instance, no Mathlib gap. ~3 extra `let`-ascriptions + the
recon022 calculus on the unified carrier + one `exact`/`convert` at `:4257`. This IS "route 2" in
STRATEGY, and it is the untried, lowest-risk path (the failed `letI` attempts all tried to *add* the
bad carrier rather than *normalize it away*).
**Verdict: ANALOGUE_FOUND.**

### Analogue 2 — `change` / `show` reducibility plumbing (re-expose the canonical head)
**Domain:** category theory · general Lean tactic engineering.
**Citation:** pervasive Mathlib idiom; concretely the `Functor.Monoidal`/`MonoidalCategoryStruct`
projection lemmas in `Mathlib.CategoryTheory.Monoidal.Transport` are stated against the canonical
head and consumers `change`/`show` the goal to that head before applying them.
**Same structural problem there:** a goal is stated with a non-canonical head that blocks a keyed
lemma; `change`/`show` rewrites the goal to the defeq canonical spelling (kernel-defeq, so always
accepted) and then the keyed lemma / instance fires.
**Technique:** before each monoidal lemma whose key is `_ ⋙ forget₂`, `show`/`change` the carrier of
the *goal* (not a hypothesis-side instance) to `X.presheaf ⋙ forget₂ …`. This re-exposes the
canonical head for the global instance without ever building a second instance.
**Mapping to project:** complements Analogue 1 — if after re-ascription a residual `rw` still snags
on a `ringCatSheaf.obj`-headed subgoal, a local `change` realigns it. **Porting cost: LOW–MED.**
Brittle alone (you must hit the exact subterm), but a cheap rescue when 1 leaves a stray snag.
**Verdict: PARTIAL_ANALOGUE.**

### Analogue 3 — `Monoidal.induced` / `fromInducedMonoidal` (`InducingFunctorData`)
**Domain:** category theory (monoidal transport).
**Citation:** `CategoryTheory.Monoidal.induced`, `…fromInducedMonoidal`, `…InducingFunctorData`
(all verified via loogle this session; module `Mathlib.CategoryTheory.Monoidal.Transport`).
`induced (F : D ⥤ C) [F.Faithful] (fData) : MonoidalCategory D` builds a *new* `MonoidalCategory` on
carrier `D` from a faithful functor into a monoidal `C` plus tensorator/unitor iso data.
**Same structural problem there:** put a `MonoidalCategory` on a carrier that does NOT inherit one by
synthesis, by transporting structure along a faithful functor — the textbook "build the instance on
the alternate carrier" tool.
**Technique:** if a genuine top-level `instance : MonoidalCategory (PresheafOfModules
X.ringCatSheaf.obj)` is ever wanted, build it via `induced` along the (faithful, defeq-identity)
comparison functor into `PresheafOfModules (X.presheaf ⋙ forget₂ …)`, supplying `InducingFunctorData`
whose `μIso`/`εIso` are identity isos. This is the kernel-accepted "re-export" the directive asks
for in (ii) — and it avoids the `inferInstanceAs` eta/aux-def failure because the fields are given
explicitly, not synthesized-then-eta-expanded.
**Crucial caveat:** `induced` (and `InducingFunctorData`, `fromInducedMonoidal`) **require
`[MonoidalCategoryStruct D]` to already exist on `D`** (verified: it is an explicit instance arg in
every signature). On `ringCatSheaf.obj` the *Struct* is exactly what fails to synthesize, so this
does NOT bypass the core blocker on its own — you would still have to supply the Struct by
ascription first, at which point Analogue 1 already finishes the job. Useful only if the project
decides it needs a reusable named instance on the bad carrier (e.g. DualInverse also wants it).
**Porting cost: MED.** **Verdict: PARTIAL_ANALOGUE.**

## Top suggestion
**Try Analogue 1 (single-carrier normalization + kernel-defeq `exact`) first.** Read the existing
`β'` re-ascription at `TensorObjSubstrate.lean:4174` as the template, and add the sibling
ascriptions `let hadj' : pushforward β' ⊣ pushforward φ' := hadj`, `let H1' : pushforward β' ≅
pullback φ' := H1`, `let μIsoβ' := μIsoβ` immediately after `:4179`. Then run the entire recon022
mate calculus (`hadj'.IsMonoidal`, `unit_app_tensor_comp_map_δ`, `Functor.Monoidal.μIso_inv`) on the
unified `_ ⋙ forget₂` carrier where the global `PresheafOfModules.monoidalCategory` is the unique
instance, and close the `:4257` `sorry` with a single `exact`/`convert` that lets the **kernel**
(not the elaborator) discharge the `ringCatSheaf.obj` ↔ `_ ⋙ forget₂` defeq — precisely the move the
project already used for the D3′ `comp_cancel_mid` family across the `SheafOfModules`↔`Scheme.Modules`
wall. First file to touch: `AlgebraicJacobian/Picard/TensorObjSubstrate.lean`, the `hδ` block
`:4154–4259`. Keep Analogue 2 (`change`) in reserve for a stray residual head; reach for Analogue 3
(`Monoidal.induced` with identity `InducingFunctorData`) only if a reusable named instance on
`ringCatSheaf.obj` is wanted later — and note it still needs the Struct supplied first.

## Discarded
- `Functor.Monoidal.transport` along `H1` — carrier non-synthesizable (directive failure; matches no
  portable technique here).
- `inferInstanceAs` / direct `letI monoidalCategory` / `haveI` Struct — these ADD the bad carrier to
  the term; Analogue 1 instead NORMALIZES it away. Do not retry.
- `noncomputable lemma` — already rejected by Lean.
