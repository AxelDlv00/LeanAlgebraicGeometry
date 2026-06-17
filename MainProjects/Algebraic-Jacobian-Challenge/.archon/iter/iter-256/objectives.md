# Iter-256 objectives — per-lane recipes (provers read this)

M=3, all bottom-up A.1.c/A.2.c, no A.3+. Gate: br256 = HARD GATE CLEARS for all three.
pc256 dispatch-sanity = OK.

---

## Lane TS-inv — `Picard/TensorObjSubstrate/DualInverse.lean` [prove]

**Single obligation: CLOSE `homOfLocalCompat` (inner f-leg smul-bridge sorry, ~L656).**
Blueprint `lem:sheafofmodules_hom_of_local_compat` (chapter `Picard_TensorObjSubstrate.tex`,
sub-step (c) now expanded by bw256). pc256 verdict = **CHURNING** (file-sorry 2→2 for 5 iters);
corrective = **execute the inline close, add NO new top-level helper declaration**.

### State (iter-255 handoff)
- (c) M-leg CLOSED via `Scheme.Modules.map_smul M` (native Γ-module level, no restrictScalars).
- SOLE residual: the f-leg. `(f i).val.app P`'s `map_smul` is over `restrictScalars 𝟙`
  (`((M.restrict (U i).ι).val.obj (op P)).isModule`); the goal's f-leg input action is the
  **native** `Γ(X, image)`-module action. Propositionally equal, NOT defeq (the `:=`/`erw`/`refine`
  defeq check rejects it even under `backward.isDefEq.respectTransparency false`).

### Inline close recipe (all ingredients named + verified to exist iter-255)
1. The open-immersion structure-ring iso is the identity:
   `AlgebraicGeometry.Scheme.Opens.ι_appIso (U i) V = Iso.refl _` ⇒ the `restrict` ring map is
   `(forget₂ …).map (Iso.refl).inv = 𝟙`.
2. So `restrictScalars 𝟙` acts as native: bridge with
   `ModuleCat.restrictScalars.smul_def` + `ModuleCat.restrictScalarsId'App` /
   `ModuleCat.restrictScalarsId'` (Mathlib `Algebra/Category/ModuleCat/ChangeOfRings.lean`):
   `c •_{restrictScalars 𝟙} x = 𝟙 c • x = c •_native x`. Realize this as a **local `have hfl : … := …`**
   (NOT a new top-level lemma — that is the churn pc256 forbids), then `erw [hfl]` so the f-leg
   action becomes native.
   - head gotcha: `(f i).val.app P |>.hom.map_smul` is headed by `ModuleCat.Hom.hom`; the goal uses
     `ConcreteCategory.hom`. Use a `ConcreteCategory.hom`-headed `show … from … map_smul …` for `erw`
     to key-match (iter-255 confirmed it matches; only the smul instance blocked).
   - `PresheafOfModules.toPresheaf_map_app_apply` converts
     `((toPresheaf).map (f i).val).app X |>.hom x ⇝ (f i).val.app X x` to reach the ModuleCat map_smul.
3. N-leg: `erw [Scheme.Modules.map_smul N]`.
4. Scalar reconciliation: `congr 1; rw [← ConcreteCategory.comp_apply, ← Functor.map_comp]; simp`
   — the two open-set `eqToHom` maps `e₁, e₂` compose to `𝟙` on the overlap because
   `(U i).ι ''ᵁ ((U i).ι ⁻¹ᵁ W) = W` (`image_preimage_of_le`, already in file).
5. On close, **remove the excuse-comment** `-- TO CLOSE (next iter): …` at ~L651 (auditor must-fix).

### Guardrails / reversing signal (pc256 must-fix)
- **DO NOT enter `dual_restrict_iso` Step-4 (~L256) this iter, EVEN IF `homOfLocalCompat` closes.**
  pc256: Step-4 is a known structural hard wall, mis-sized after a 5-PARTIAL prerequisite; it must
  get a recipe (analogist/blueprint) before a prover round. If you close `homOfLocalCompat`, report
  the milestone and STOP.
- **NO new top-level helper declaration.** Local `have`s only.
- If the f-leg smul bridge does NOT fire inline → STOP, report the EXACT remaining goal + which
  rewrite (`smul_def`/`restrictScalarsId'App`/`erw`) failed and why. Do NOT add a wrapper helper, do
  NOT enter Step-4. (iter-257 then escalates to a mathlib-analogist consult on this exact bridge —
  this is the armed CHURNING tripwire.)
- Keep the file GREEN (TensorObjSubstrate.lean imports nothing from here, but RPF/consumers do).

**Bar:** CLOSE `homOfLocalCompat`. Nothing else.

---

## Lane TS-cmp — `Picard/TensorObjSubstrate.lean` [prove]

**Scaffold + prove D3′ `pullbackTensorMap_restrict`** (blueprint `lem:pullback_tensor_map_basechange`,
chapter `Picard_TensorObjSubstrate.tex` L3876). pc256 verdict = **CONVERGING** (D1′ closed iter-255;
all D3′ deps now leanok). This is the next sub-lemma toward D4′ `pullbackTensorIsoOfLocallyTrivial`.

### Statement to scaffold (from the blueprint block, project notation)
For `f : Y ⟶ X`, an open `U ⊆ X` with preimage `f⁻¹U ⊆ Y`, `g : f⁻¹U → U` the restriction of `f`,
open immersions `j : U ↪ X`, `j' : f⁻¹U ↪ Y` (so `f ∘ j' = j ∘ g`): for all `M, N : X.Modules`, the
restriction `(j')^*(δ^f_sheaf(M,N))` coincides — through the pullback pseudofunctoriality iso
`pullbackComp` of `f ∘ j' = j ∘ g` — with `δ^g_sheaf(j^*M, j^*N)`; in particular the restriction of
`δ^f_sheaf(M,N)` to `f⁻¹U` is an iso iff `δ^g_sheaf(j^*M,j^*N)` is. `\lean{}` name =
`AlgebraicGeometry.Scheme.Modules.pullbackTensorMap_restrict`.

### Recipe — MIRROR the proven unit analog `pullbackObjUnitToUnit_comp` (L907–~960)
That lemma already executes the EXACT mate calculus for the UNIT (η); D3′ is its tensorator (δ)
analog. Read its proof and adapt:
- `Functor.OplaxMonoidal.comp_δ` [verified — Mathlib `Monoidal/Functor.lean:997`] decomposes the δ of
  the composite oplax functor into the whiskered composite of the factors' δ's. Apply to the two
  factorizations of the underlying functor of `f ∘ j' = j ∘ g`: as `(j')^* ∘ f^*` and as `g^* ∘ j^*`.
- Conjugate the pullback pseudofunctoriality iso via
  `Scheme.Modules.conjugateEquiv_pullbackComp_inv` [verified — used at L918] (pullbackComp for the
  left adjoints ↔ pushforwardComp for the right adjoints), transposing across the composed
  `pullbackPushforwardAdjunction` exactly as the unit analog does (`unit_conjugateEquiv` →
  the tensor/δ version; transpose via `…homEquiv`).
- Restriction along `j'` is the strong-monoidal restriction functor `tensorObj_restrict_iso`
  [verified — L443], so it carries `δ^f_sheaf` to its value on the restricted modules with no defect.
- Reuse the **D1′ canonical-spelling device** if `comp_δ` fails `MonoidalCategory` synthesis on the
  `X.ringCatSheaf` spelling: ascribe the ring-hom at the canonical
  `X.presheaf ⋙ forget₂ CommRingCat RingCat` form via `show … from …` inside the `comp_δ` `F :=`
  argument (this is the verified mapin255 pattern; NOT the non-transferable `(C := …)` device).
- Final clause (iso iff iso) is immediate: an iso is preserved+reflected by the pseudofunctoriality
  iso it is conjugated by.

### Cleanup (you own this file)
- Fix the stale module status block ~L41–43 (auditor major): it claims "TWO tracked typed-sorry
  residuals (iter-254)" naming `pullbackTensorMap_natural` — that closed iter-255. Update to ONE
  residual (`exists_tensorObj_inverse` only) and record D1′ CLOSED iter-255.

### Guardrails
- Do NOT touch `exists_tensorObj_inverse` (L712, cross-file gated). Keep D1′/D2′ GREEN.
- D4′ (`pullbackTensorIsoOfLocallyTrivial`) is NOT this iter — D3′ only.
- **Bar:** scaffold `pullbackTensorMap_restrict` + make real proof progress; close it if the
  unit-analog mirror goes through. If a genuinely new obstacle appears beyond the unit-analog pattern
  → leave the scaffolded sorry, report the exact failing step (do NOT invent a new device).

---

## Lane engine — `Picard/LineBundleCoherence.lean` [prove — FILE-SKELETON ONLY]

**Scaffold the file from `Picard_LineBundleCoherence.tex` + de-risk the site instances.**
pc256 verdict = **UNCLEAR** (fresh route); scope = scaffold + investigate, **NO proof attempts**.

### Create `AlgebraicJacobian/Picard/LineBundleCoherence.lean` with imports + namespace + these 5
declarations as `sorry` stubs (signatures matching the chapter `\lean{}` pins):
- `AlgebraicGeometry.Scheme.LineBundle.IsLocallyTrivial.exists_trivializing_cover`
  (`lem:lbc_trivializing_cover`)
- `AlgebraicGeometry.Scheme.LineBundle.IsLocallyTrivial.chartPresentation` (`lem:lbc_chart_presentation`)
- `AlgebraicGeometry.Scheme.LineBundle.IsLocallyTrivial.isFinitePresentation`
  (`thm:lbc_isFinitePresentation`) — the main theorem (assembles `QuasicoherentData` from the
  trivialising cover, invokes `SheafOfModules.IsFinitePresentation.mk`)
- `AlgebraicGeometry.Scheme.LineBundle.IsLocallyTrivial.isFiniteType` (`cor:lbc_isFiniteType`)
- `AlgebraicGeometry.Scheme.LineBundle.IsLocallyTrivial.chart_free_rank_one` (`lem:lbc_rank_flat`)

### De-risk investigation (the first-iter point — REPORT, do not prove)
The chapter's `rem:lbc_site_instances` flags the single typecheck risk: the site instances on
`J.over X` / `X.ringCatSheaf` that `SheafOfModules.IsFinitePresentation` / `QuasicoherentData`
machinery needs. Investigate and REPORT, present-or-absent, each of:
`HasWeakSheafify`, `WEqualsLocallyBijective`, `HasSheafCompose` (and anything else
`SheafOfModules.IsFinitePresentation.mk` requires) for the relevant site. Use `lean_*` search /
`#synth`-style probes inside the scaffolded file. If any are absent, name precisely which — that
becomes the iter-257 decision (open a full prover lane vs dispatch a mathlib-analogist first).

### Guardrails
- **Do NOT attempt any proof** (pc256: over-reach burns capacity). All bodies stay `sorry`.
- Add the import(s) the chapter implies (loc-triv line bundle infra; `SheafOfModules.IsFinitePresentation`).
- **Bar:** file compiles with the 5 sorry stubs + a clear site-instance presence/absence report in
  the task result.
