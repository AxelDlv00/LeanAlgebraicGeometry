# AlgebraicJacobian/Picard/TensorObjSubstrate.lean

## Summary
- **Declarations added (3, all axiom-clean `{propext, Classical.choice, Quot.sound}`):**
  - `PresheafOfModules.dualPrecompEquiv` (line 1558) — section-level `R(U)`-linear precomposition equivalence on dual sections.
  - `PresheafOfModules.dualIsoOfIso` (line 1603) — presheaf-level "dual respects isos" (`e : M ≅ M' → dual M' ≅ dual M`).
  - `AlgebraicGeometry.Scheme.Modules.dualIsoOfIso` (line 1698) — sheaf-level "dual respects isos".
- **Declarations blocked (1):** the C-bridge `dual_isLocallyTrivial` did **NOT** land (its load-bearing `dual_restrict_iso` is blocked — precise residual below). NOT stubbed (no sorry).
- **Sorry count in file: 80→80 (3 file sorries, ALL pre-existing: L691, L2165, L2211). I added ZERO sorries.**
- Full file compiles with **no errors** (only the pre-existing `Sheaf.val` deprecation + `opaque` warnings).

## C-bridge `dual_restrict_iso` / `dual_isLocallyTrivial` — BLOCKED (precise blocker, empirically confirmed)

**This is the hard-block input.** I empirically drafted `dual_restrict_iso` as the requested verbatim
mirror of the CLOSED `tensorObj_restrict_iso` and read off the exact residual via `lean_goal`.

**Finding: Steps 1–3 + H1 of the mirror typecheck CLEANLY for the dual** (no errors), exactly as the
blueprint predicted — `restrictFunctorIsoPullback` → `sheafificationCompPullback` → strip
sheafification (`.mapIso`) → H1 (`pushforwardPushforwardAdj.leftAdjointUniq pullbackPushforwardAdjunction`)
all apply generically. After H1 the residual goal is **exactly**:

```
⊢ (PresheafOfModules.pushforward β).obj M.val.dual ≅ (M.restrict f).val.dual
```

i.e. (using `(M.restrict f).val = (pushforward β).obj M.val` defeq):

```
(pushforward β).obj (PresheafOfModules.dual A) ≅ PresheafOfModules.dual ((pushforward β).obj A)
```

— **pushforward along the open-immersion structure map `β` commutes with the presheaf dual
`PresheafOfModules.dual = internalHom(-, 𝟙_)`.**

**Why this is NOT a verbatim mirror (the blueprint's "verbatim mirror" claim breaks at H2′):**
- The tensor's H2 closed this shape via `Functor.Monoidal.μIso` of `restrictScalarsMonoidalOfBijective`,
  because the **presheaf tensor `tensorObj M N` is SECTIONWISE** `M(U) ⊗_{R(U)} N(U)` — a literal
  `restrictScalars`-image, so the sectionwise strong-monoidal tensorator applies.
- `PresheafOfModules.dual = internalHom(-, 𝟙_)` is the **SLICE internal hom**: its value
  `(internalHom A 𝟙_).obj U = (restr U A ⟶ restr U 𝟙_)` is a morphism module over the over-category
  `Over U` (a compatible family over all `V ≤ U`), **NOT** a sectionwise `restrictScalars`-image. There
  is therefore **no sectionwise strong-monoidal-closed analogue** of `restrictScalarsMonoidalOfBijective`
  for the dual, and `restrictScalarsRingIsoDualEquiv` (the H2′ core, iter-227) is only the ModuleCat-level
  *shadow* — it cannot be lifted the way the tensor's `restrictScalarsRingIsoTensorEquiv` was.
- Mathlib has **no** `PresheafOfModules`/`SheafOfModules` internal hom (confirmed: `loogle` for
  `PresheafOfModules.internalHom` / `SheafOfModules.dual` → no results), so the slice machinery is the
  only path.

**The genuine missing infrastructure:** closing the residual requires building the **equivalence of slice
sites induced by the open immersion** `f` — for `V ∈ Opens Y`, the over-category `Over V` (in `Opens Y`)
is equivalent to `Over (f''V)` (in `Opens X`, `f''V` = image of `V`), and this equivalence transports
the morphism modules `(restr_X (f''V) A ⟶ restr_X (f''V) 𝟙_X) ≅ (restr_Y V (pushforward A) ⟶ restr_Y V 𝟙_Y)`
naturally — together with its compatibility with `restr`/`pushforward₀`. This is a substantial
Mathlib-absent build (~150–300 LOC, `Over.map`/equivalence pseudofunctor coherence), **NOT** a verbatim
mirror and **NOT** discharged by the pre-built `restrictScalarsRingIsoDualEquiv`. This is a genuine block
(not mid-build budget exhaustion): the "verbatim mirror" route bottoms out at H2′.

## dualPrecompEquiv (line 1558) — RESOLVED, axiom-clean
- **Approach:** `LinearEquiv` on dual-section modules; `φ ↦ (pushforward₀(Over.forget U)).map e.hom ≫ φ`,
  inverse via `e.inv`. `R(U)`-linearity = post-comp `globalSMul` commutes with pre-comp (`Category.assoc`);
  inverse identities via `Functor.map_comp` + `e.{hom_inv,inv_hom}_id` + `Functor.map_id`.
- **Gotchas:** (1) `Preadditive.comp_add` has **explicit object args** `(P Q R)` — call as
  `Preadditive.comp_add _ _ _ _ φ ψ`. (2) `Functor.map_id` mis-resolves to the monad `<$>` form — must
  qualify `CategoryTheory.Functor.map_id`. (3) structure-field lambdas need `change` (not bare `rw`) to
  beta-reduce before `← Category.assoc`. (4) the module `+`/`•` on the Hom type are the Preadditive ones
  but appear as local `letI` instances — `rw` fails on them, use defeq-driven `exact`.

## dualIsoOfIso (presheaf, line 1603) — RESOLVED, axiom-clean
- **Approach:** `PresheafOfModules.isoMk (fun U => (dualPrecompEquiv e U.unop).toModuleIso)`.
- **Result:** the `isoMk` naturality discharged by the **default `cat_disch`** — the slice-restriction
  coherence `restrictionMap g ((pushforward₀(Over.forget U)).map e.hom) = (pushforward₀(Over.forget V)).map e.hom`
  is essentially definitional (`Over.map g ⋙ Over.forget U = Over.forget V` on `.left`), so no manual
  naturality proof was needed. (This confirms the dual *is* cleanly contravariantly functorial in isos —
  the slice obstruction is specific to the open-immersion **pushforward** commutation, not to iso-functoriality.)

## Scheme.Modules.dualIsoOfIso (line 1698) — RESOLVED, axiom-clean
- **Approach:** `sheafification.mapIso (PresheafOfModules.dualIsoOfIso ((SheafOfModules.forget _).mapIso e))`.
  Dual analogue of `tensorObjIsoOfIso`. Contravariant: `e : M ≅ M' → dual M' ≅ dual M`.

## dual_unit_iso (`internalHom 𝟙_ 𝟙_ ≅ 𝟙_`) — NOT ADDED (bounded attempt, abandoned)
- **Purpose:** the second assembly ingredient — `dual 𝒪_U ≅ 𝒪_U` — which, together with `dualIsoOfIso`
  and the blocked `dual_restrict_iso`, would complete `dual_isLocallyTrivial`.
- **Approach attempted:** the rank-one lemma `globalSMul_unit_eq : φ = globalSMul (φ(1))` for any endo `φ`
  of `restr U 𝟙_` (regular representation is internally free of rank one). **Blocked immediately on unit
  plumbing:** the unit carrier `(restr U 𝟙_).obj (op (Over.mk (𝟙 U)))` has **no `OfNat 1` instance** — the
  generator `1` of the monoidal unit `𝟙_` must be accessed through `PresheafOfModules.unit`'s internal
  section API (cf. `unit_map_one`), not as a bare ring `1`. Removed (no sorry left).
- **Next step (precise):** build `globalSMul_unit_eq` using the correct unit-generator term + `φ`'s
  naturality (mirroring the `internalHomEval` `naturality_apply`/`restr_map_homMk` juggling), then
  `dual_unit_iso` via `isIso_of_isIso_app` on `r ↦ globalSMul r`. ~80–150 LOC; off the critical path
  (the C-bridge is blocked on `dual_restrict_iso` regardless).

## Why I stopped
**Partial progress.** 3 axiom-clean on-path declarations added (`dualPrecompEquiv` L1558,
`PresheafOfModules.dualIsoOfIso` L1603, `Scheme.Modules.dualIsoOfIso` L1698) — the "dual respects isos"
ingredient of the `dual_isLocallyTrivial` assembly, plus its section-level core. The **C-bridge itself did
NOT land** and per the sharpened bar does **not** count as route progress: its load-bearing `dual_restrict_iso`
is **genuinely blocked** at the H2′ presheaf residual `(pushforward β).obj (dual A) ≅ dual((pushforward β).obj A)`,
empirically confirmed (Steps 1–3 + H1 typecheck; the residual is the **slice-internal-hom vs. sectionwise
mismatch** — the dual has no sectionwise strong-monoidal analogue, so it is **NOT** a verbatim mirror and
**NOT** dischargeable by `restrictScalarsRingIsoDualEquiv`). Closing it requires the open-immersion
slice-site equivalence (~150–300 LOC Mathlib-absent). The secondary A-engine `localSection` was gated on
C landing axiom-clean, so it was not started.

**Hard-block input for the USER escalation:** this is a genuine block (route bottoms out at H2′), not
mid-build budget exhaustion. The blueprint's "verbatim mirror" route for `lem:dual_isLocallyTrivial` is
**incorrect past Step 3/H1** — the dual's slice structure breaks the sectionwise tensorator lift that made
the tensor case work.

## Blueprint flags (for the writer/review agent — provers don't edit blueprints)
- `lem:dual_isLocallyTrivial` proof sketch (`Picard_TensorObjSubstrate.tex` ~L2800) claims a "verbatim
  mirror"; this is **wrong at H2′** (see blocker above). Recommend the writer correct the sketch: Steps 1–3
  + H1 mirror, but H2′ needs an open-immersion slice-site equivalence, not `restrictScalarsRingIsoDualEquiv`.
- The 3 new axiom-clean decls are **not yet `\lean{}`-pinned**. Suggest the planner add blueprint blocks
  (e.g. `def:dual_iso_of_iso` / `lem:dual_precomp_equiv`) so `sync_leanok` can track them — they are genuine,
  reusable assembly ingredients (the dual analogue of `tensorObjIsoOfIso`).
