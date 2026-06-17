# Iter-239 — detailed objectives

## Lane 1 — `Picard/TensorObjSubstrate.lean` [mathlib-build]: `IsInvertible.pullback` substrate

**Why:** the group law `picCommGroup` landed iter-238 on the `IsInvertible` carrier. The next
critical-path step (A.1.c — author the relative Picard functor on `IsInvertible`) requires that
**pullback preserves tensor-invertibility** for GENERAL scheme morphisms (the projection
`C×_S T → T` and the base-change `g_C : C×_S T' → C×_S T` are neither open immersions nor flat). This
is the substrate prerequisite; without it the consumer cannot be authored on `IsInvertible`.

**Blueprint:** `Picard_TensorObjSubstrate.tex`, new section `sec:tensorobj_pullback_monoidality`
(`lem:pullback_tensor_iso`, `lem:pullback_unit_iso`, `lem:isinvertible_pullback`), written + cleaned this
iter; SOURCE = Stacks `lemma-tensor-product-pullback` / `lemma-pullback-invertible`
(references/stacks-modules.tex).

**Targets (bottom-up):**
1. `pullbackTensorIso` : `(Scheme.Modules.pullback f).obj (tensorObj M N) ≅ tensorObj ((pullback f).obj M)
   ((pullback f).obj N)` for any `f : Y ⟶ X`. Recipe — mirror `tensorObj_restrict_iso` but via the LEFT
   adjoint: (a) `SheafOfModules.sheafificationCompPullback` [verified present] moves the pullback inside
   sheafification → presheaf-level goal; (b) the presheaf pullback is strong monoidal sectionwise via
   `(extendScalars f).Monoidal` [verified, `Mathlib/Algebra/Category/ModuleCat/Monoidal/Adjunction.lean`];
   its tensorator `μ`, sheafified, gives the iso. Do NOT route through `pushforward`/`restrictScalars`
   (the lax right adjoint — that is the open-immersion-only `tensorObj_restrict_iso` route).
2. `pullbackUnitIso` : `(pullback f).obj (unit) ≅ unit` (`f^*𝒪_X ≅ 𝒪_Y`). From the `ε` unit comparison of
   `(extendScalars f).Monoidal` (`S ⊗_R R ≅ S`). OPEN sub-question handed to prover (blueprint flags it):
   is Mathlib's `SheafOfModules.pullbackObjUnitToUnit` an iso for general `f` (it is for open immersions
   via finality, used in `IsLocallyTrivial.pullback`), or must the iso come from the `extendScalars` `ε`?
3. `IsInvertible.pullback` : `IsInvertible M → IsInvertible ((pullback f).obj M)`. Stacks proof: witness
   `(pullback f).obj N`; iso `pullbackTensorIso.symm ≪≫ (pullback f).mapIso e ≪≫ pullbackUnitIso`.

**mathlib-build invariant:** no sorry pins. Land 1–3 axiom-clean as far as possible; if `pullbackTensorIso`
needs presheaf-monoidal assembly that doesn't close in one iter, commit the unit iso + whatever presheaf
comparison lands and hand off a precise decomposition. progress-critic ts239 watch: if the first attempt
adds ≥3 helpers without closing `IsInvertible.pullback`, the next step is a mathlib-analogist consult on
`sheafificationCompPullback` carrier semantics — NOT another blind dispatch.

## Lane 2 — `Cohomology/FlatBaseChange.lean` [prove]: close `affineBaseChange_pushforward_iso`

**Status:** progress-critic ts239 = STUCK, but **one post-corrective attempt is justified** — the iter-238
blueprint expansion gave the prover the element-free `D(a)`-transport recipe it lacked (material new info,
not a verbatim re-dispatch).

**Target:** the sorry at L470 (`affineBaseChange_pushforward_iso`). Build the unconditional
`pushforward_spec_tilde_iso` by discharging `hloc` via the element-free `D(a)`-level transport
(`e_{D(a)}` linear equiv mirroring `gammaPushforwardIso` + the `D(a)` ring equation +
`IsLocalizedModule.of_linearEquiv` / `IsLocalizedModule.powers_restrictScalars` transport of `M[1/φa]`),
then feed `pushforward_spec_tilde_iso_of_isLocalizedModule` (L395, conditional, already axiom-clean) ⇒
unconditional brick ⇒ close `affineBaseChange_pushforward_iso`.
Blueprint: `Cohomology_FlatBaseChange.tex`, `lem:pushforward_spec_tilde_iso` (expanded last iter).

**Do NOT attempt** the L492 sorry `flatBaseChange_pushforward_isIso` (deep Čech+flatness; documented).

**HARD reversing signal (progress-critic ts239):** if sorry stays at 2 after this iter's review, the next
corrective is a ROUTE PIVOT (a different decomposition of `affineBaseChange_pushforward_iso` that does NOT
traverse `hloc` via `IsLocalizedModule.of_linearEquiv` — e.g. a direct scheme-level `IsQuasicoherent`
criterion), preceded by a mathlib-analogist consult. NOT a fourth blueprint expansion. The smul carrier
wall has now recurred at 3 section locations (`⊤` → Γ → `D(a)`); a 4th recurrence means the architectural
path itself is the problem.

## Deferred this iter
- RPF (`RelPicFunctor.lean`) re-base — gated on Lane 1 (`IsInvertible.pullback`) landing. Next iter:
  author `OnProduct`/`pullbackAlongProjection`/`functorial`/`PicSharp` on `IsInvertible` (in
  `LineBundlePullback.lean` + `RelPicFunctor.lean`), `addCommGroup` = additive transport of `picCommGroup`.
  Will need a `Picard_RelPicFunctor.tex` + `Picard_LineBundlePullback.tex` writer pass first.
- HigherDirectImage, CMRegularity/SemiContinuity chapters — gap-blocked (unchanged).
