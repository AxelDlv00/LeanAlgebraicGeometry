# Analogy: SerreFiniteness affine-acyclicity — parallel API vs the carrier substrate

## Mode
api-alignment

## Slug
serre-affine-acyclic-substrate-align

## Iteration
026

## Question
Should the false free-standing `HModule_affine_acyclic` (+ bespoke `cechH1OfTwoAffine`)
in `SerreFiniteness.lean` be DELETED and re-aligned onto the existing carrier substrate
(`IsAffineHModuleVanishing` / `IsCechAcyclicCover` / `cechCohomology` + `compIso`), or
is the cheaper minimal patch (add a quasi-coherence hypothesis to the free theorem) the
right call? Plus: is an `instance IsAffineHModuleVanishing kbar C (toModuleKSheaf C)` the
honest replacement; is there a `HModule ≅ HModule' ⊤` bridge; does Mathlib offer a qcoh /
affine-vanishing predicate for `ModuleCat k`-valued sheaves over `Opens X`?

## Project artifact(s)
- `AlgebraicJacobian/Cohomology/SerreFiniteness.lean:71` — `HModule_affine_acyclic` (FALSE ∀-claim; `sorry`).
- `…/SerreFiniteness.lean:120,136` — `cechH1OfTwoAffine`, `HModule_one_iso_cechH1` (bespoke, `sorry`).
- `…/SerreFiniteness.lean:181,194` — consumers `HModule_structureSheaf_higher_vanish`, `HModule_sheafOf_higher_vanish`.
- `…/StructureSheafModuleK/Carriers.lean:222` — `class IsAffineHModuleVanishing` (HModule').
- `…/Carriers.lean:612` — `class Scheme.IsCechAcyclicCover`; `:573` `cechCohomology`; `:635/656` `subsingleton_HModule'_supr_of_isCechAcyclicCover[_curve]` (takes explicit `compIso`).
- Substrate is **self-contained**: grep shows NO consumer of any carrier decl outside Carriers.lean.

## Decisions identified

### Decision: keep-the-false-free-theorem (minimal qcoh patch) vs delete + align

- **Mathlib idiom**: vanishing/finiteness facts about cohomology are stated against a
  *predicate on the sheaf* (`SheafOfModules.IsQuasicoherent`, an `ObjectProperty`,
  `Mathlib.Algebra.Category.ModuleCat.Sheaf.Quasicoherent`), discharged by **instances on
  specific sheaves** — never as a free ∀-theorem over all `F` with only a topological
  hypothesis. The project's own `IsAffineHModuleVanishing` (Carriers L222) already mirrors
  exactly this idiom.
- **Project's current path**: `HModule_affine_acyclic` asserts, for ARBITRARY
  `F : Sheaf (Opens X) (ModuleCat k)` with only `hAffine` (X ≅ Spec A, purely topological)
  and `p>0`, that `Subsingleton (HModule k F p)`. This is a **false universal** — Serre/
  Grothendieck affine vanishing holds only for *quasi-coherent* F; an arbitrary abelian
  sheaf on Spec A (e.g. a constant/locally-constant sheaf with nontrivial topology) can
  have nonzero higher cohomology. The `sorry` is therefore **unfillable / unsound**, not
  merely unproven.
- The "minimal patch" (add a qcoh hypothesis) is **illusory**: Q4 confirms Mathlib has NO
  qcoh predicate for this category, so the hypothesis would have to be a *project-local*
  predicate — i.e. you would reinvent `IsAffineHModuleVanishing` at `HModule` instead of
  `HModule'`, producing a THIRD parallel API. A qcoh hypothesis strong enough to make the
  theorem true but with no producer is dead scaffolding; a hypothesis that IS the
  conclusion (affine-acyclic ⇒ vanishes) is circular.
- **Gap**: divergent-and-wrong (false theorem) + divergent-with-cost (parallel API).
- **Cost of divergence**: (a) an unsound `sorry` sitting on a false statement, citable by
  any downstream proof — a soundness landmine; (b) two parallel acyclicity APIs
  (`HModule_affine_acyclic` at HModule vs `IsAffineHModuleVanishing`/`IsCechAcyclicCover`
  at HModule') that must eventually be unified, each needing the same hard producer; (c)
  the bespoke `cechH1OfTwoAffine` duplicates `Scheme.cechCohomology C F 𝒰 1`.
- **Verdict**: ALIGN_WITH_MATHLIB (DELETE the false theorem; re-align onto the carriers).

### Decision: is `instance IsAffineHModuleVanishing kbar C (toModuleKSheaf C)` the honest replacement?

- **Mathlib idiom**: `SheafOfModules.IsQuasicoherent` is a `Prop` predicate; it is never
  asserted ∀-universally — it is *proved as an instance for specific sheaves* where true.
  A typeclass is a hypothesis, not a theorem.
- **Project's path**: `IsAffineHModuleVanishing k C F` is a single-field `Prop` class
  (hypothesis). For arbitrary F it is simply **not claimed**; producing
  `instance IsAffineHModuleVanishing kbar C (toModuleKSheaf C)` (and `(sheafOf D)`)
  discharges it only where it is **true** (O_C, O_C(D) are quasi-coherent).
- **Gap**: identical to the Mathlib idiom.
- **Verdict**: PROCEED — framing is sound. A carrier class is NOT a false universal; it is
  the honest dual of the false free theorem. This is the correct replacement: delete the
  ∀-theorem, supply an instance only at the quasi-coherent sheaves the chapter consumes.

### Decision: HModule (whole-space) vs HModule' (open-eval) — is there a bridge?

- **Mathlib idiom**: cohomology-of-an-open is `Ext(よ(X) sheafified, F)`; global cohomology
  is `Ext(constant/terminal, F)`. The bridge is the iso of the two SOURCE objects at X=⊤.
- **Project's path**: `HModule k F n = Ext(constantSheaf.obj (of k k), F) n` (Carriers L52);
  `HModule' k F n X = Ext((presheafToSheaf).obj ((よ ⋙ free k).obj X), F) n` (Carriers L99).
  Affine-acyclicity / Čech naturally live at **HModule'** (evaluation at an open U / at
  ⨆𝒰). SerreFiniteness's targets are at **HModule**.
- **Bridge status**: **DOES NOT EXIST** (grep: no `HModule ≅ HModule' ⊤`, no such lemma).
  Mathematically sound and needed: `(constantSheaf J _).obj (of k k) ≅
  (presheafToSheaf _ _).obj ((よ ⋙ free k).obj ⊤)` because `よ.obj ⊤` is the terminal
  presheaf, `free k` of it is the constant presheaf at `k`, whose sheafification is the
  constant sheaf — so the two Ext-sources agree, giving `HModule k F n ≃ₗ HModule' k F n ⊤`
  by contravariant `Ext` functoriality in the first argument (`Abelian.Ext.mk₀` of the
  precomposition, exactly the transport pattern already in SerreFiniteness's
  `HModule_linearEquiv_of_iso` L456, but on the SOURCE not the sheaf).
- **Gap**: missing infrastructure.
- **Verdict**: NEEDS_MATHLIB_GAP_FILL (project-local; new leaf, low–medium difficulty).

### Decision: does Mathlib offer qcoh / affine-vanishing for `Sheaf (Opens X) (ModuleCat k)`?

- **Mathlib reality**: `SheafOfModules.IsQuasicoherent`
  (`Mathlib.Algebra.Category.ModuleCat.Sheaf.Quasicoherent`) requires `R : Sheaf J RingCat`
  and `M : SheafOfModules R` — a sheaf of modules **over a sheaf of rings (O_X)**. The
  project's `Sheaf (Opens X) (ModuleCat k)` are constant-coefficient `k`-module-valued
  sheaves, NOT O_X-modules; different category, no coercion. Affine cohomology vanishing
  (Serre) is **absent from Mathlib entirely** — even `CategoryTheory.Sheaf.H` is
  `AddCommGrpCat`-only (the very reason the project built `HModule`), with no affine
  vanishing lemma attached.
- **Gap**: no applicable Mathlib idiom.
- **Verdict**: NEEDS_MATHLIB_GAP_FILL — re-confirms iter-025. The project MUST build the
  affine-vanishing itself; the carrier class + its (still-unbuilt) producer is the vehicle.

## Recommendation

DELETE `HModule_affine_acyclic` (false ∀-claim / unsound sorry) and re-align SerreFiniteness
onto the carrier substrate. The minimal qcoh-hypothesis patch is rejected: with no Mathlib
qcoh predicate (Q4), it would only spawn a third parallel API. Honest leaf decomposition:

**Delete (false / pure-duplicate):**
- `HModule_affine_acyclic` (L71) — false universal; delete outright.

**Re-express onto substrate (parallel → bridged specialization):**
- `cechH1OfTwoAffine` (L120) → `Scheme.cechCohomology C (toModuleKSheaf C) 𝒰₂ 1` for the
  two-affine cover `𝒰₂`. A concrete cokernel presentation MAY be kept *iff* bridged to
  `cechCohomology` (the Riemann-inequality finiteness proof may want the concrete form);
  it must not stay parallel.
- `HModule_one_iso_cechH1` (L136) → instance of the substrate comparison `compIso 1`.

**New honest leaves (typed sorries — these REPLACE the false theorem):**
1. `instance IsAffineHModuleVanishing kbar C (toModuleKSheaf C)` — TRUE (O_C qcoh). [the honest replacement]
2. `instance IsAffineHModuleVanishing kbar C (WeilDivisor.sheafOf D)` — TRUE (O_C(D) qcoh).
3. `instance IsCechAcyclicCover (toModuleKSheaf C) 𝒰₂` (and for `sheafOf D`) — from (1)/(2)
   via the acyclic-cover/Leray principle (Stacks 01EW); typed sorry.
4. `compIso n : cechCohomology C F 𝒰 n ≃ₗ HModule' k F n (⨆𝒰)` — the genuinely hard
   Čech-vs-derived comparison the substrate explicitly left "queued"; typed sorry/def.
5. `HModule_iso_HModule'_top : HModule k F n ≃ₗ HModule' k F n ⊤` — the missing whole-space
   bridge (Q3); typed sorry/def, low–medium.

**Consumers rewire:**
- `HModule_structureSheaf_higher_vanish` / `HModule_sheafOf_higher_vanish` (L181/194):
  `IsCechAcyclicCover (…) 𝒰₂` → `subsingleton_HModule'_supr_of_isCechAcyclicCover` (gives
  `Subsingleton (HModule' … n ⊤)`, since `⨆𝒰₂=⊤`) → bridge (5) → `Subsingleton (HModule … n)`.
  Note: even degrees ≥2 (combinatorially free for a 2-element cover) still route through
  `compIso`, which needs the affine-acyclicity input (1)/(2) — that is precisely why the
  false free theorem could not be escaped without the carrier producer.
- `cechH1_finiteDimensional` / `HModule_structureSheaf_H1_finite` (L152/168): retarget to
  `FiniteDimensional kbar (cechCohomology C (toModuleKSheaf C) 𝒰₂ 1)` and transport via
  `compIso 1` ≫ bridge (5).

Net: 1 deletion, 2 re-expressions, 5 new typed sorries (one of which, the
`IsAffineHModuleVanishing (toModuleKSheaf C)` instance, is the *honest* form of the deleted
false theorem), 4 consumers rewired. The false ∀-`sorry` becomes an instance-on-a-specific-
sheaf `sorry` — same proof burden, but no longer a soundness landmine and no longer a
parallel API.
