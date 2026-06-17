# AlgebraicJacobian/Picard/TensorObjSubstrate.lean

## Summary

- **Declarations added (3 axiom-clean):**
  - `AlgebraicGeometry.Scheme.Modules.homMk` (def) — A-bridge **step (ii)**, the
    "promote an `𝒪_X`-linear `Ab`-presheaf morphism to a module morphism" half of
    `homOfLocalCompat`. Axioms `[propext, Classical.choice, Quot.sound]`.
  - `AlgebraicGeometry.Scheme.Modules.toPresheaf_map_homMk` (`@[simp]` lemma) — its
    defining property: `(toPresheaf X).map (homMk g hg) = g`. Axiom-clean (`rfl`).
  - `PresheafOfModules.restrictScalarsRingIsoDualEquiv` (def) — C-bridge **H2′ core**
    (the `Hom`/dual analogue of `restrictScalarsRingIsoTensorEquiv`): for a ring iso
    `e : R ≃+* S`, `restrictScalars_e(M →ₗ[S] S) ≃ₗ[R] (restrictScalars_e M →ₗ[R] R)`.
    Axioms `[propext, Quot.sound]` (even cleaner — no `Classical.choice`).
- **Blocked (not added, NO sorry pinned):** `homOfLocalCompat` (the full A-bridge
  gluing engine). Precise blocker below.
- **Comment hygiene ride-along (a,b,c):** all applied.
- **C-probe verdict:** **DECISIVELY d.2-FREE** (escalation tripwire NOT triggered on
  the C-front). Backed by the axiom-clean `restrictScalarsRingIsoDualEquiv` datapoint.
- **sorry count:** file 3 → 3 (unchanged; pre-existing sorries at L659
  `isLocallyInjective_whiskerLeft_of_W`, L2074 `exists_tensorObj_inverse`, L2139
  `addCommGroup_via_tensorObj` — all FORBIDDEN this iter, untouched). Project 80 → 80.
- Build GREEN (`lean_diagnostic_messages` success, no errors, only warnings).

## `homMk` + `toPresheaf_map_homMk` (lines ~1986–2008) — RESOLVED, axiom-clean
- **Approach:** wrap `PresheafOfModules.homMk (M₁ := M.val) (M₂ := N.val) g hg` in the
  `SheafOfModules.Hom` constructor `⟨·⟩`. The linearity hypothesis is stated over
  `X.ringCatSheaf.obj.obj V` / `M.val.obj V` carriers (the `Scheme.Modules.presheaf`
  def does NOT unfold for instance synthesis — must use `M.val.presheaf` syntactically,
  and the codomain smul instance is only found on the `.val.presheaf` path).
- **Result:** RESOLVED. This is genuinely step (ii) of `homOfLocalCompat`: once the
  ab-sheaf gluing (step i) produces the linear `g`, `homMk` turns it into the `M ⟶ N`.
- **Gotcha for next iter:** a section-level `@[simp]` lemma `((homMk g hg).val.app V).hom
  = (g.app V).hom` is FALSE-typed (`PresheafOfModules` `.app` is a `LinearMap`, `g.app V`
  an `AddMonoidHom`); use `toPresheaf_map_homMk` (the `Ab`-level identity) instead.

## `restrictScalarsRingIsoDualEquiv` (lines ~290–340) — RESOLVED, axiom-clean
- **Approach:** explicit `LinearEquiv`, forward `φ ↦ e.symm ∘ φ`, inverse `ψ ↦ e ∘ ψ`.
  `Module R`-structures via `Module.compHom · e.toRingHom` (placed in the SIGNATURE
  via `letI`, mirroring `restrictScalarsRingIsoTensorEquiv`). Linearity by
  `hsmulM : r • m = e r • m` (rfl) + `map_smul`/`map_mul`/`e.symm_apply_apply`.
- **Result:** RESOLVED. This is the **start of the C-build** — the d.2-free H2′ ingredient.
  `ModuleCat.restrictScalarsEquivalenceOfRingEquiv : R ≃+* S → (ModuleCat S ≌ ModuleCat R)`
  (`ChangeOfRings.lean:285`) is the categorical packaging; `restrictScalarsRingIsoDualEquiv`
  is the concrete `LinearEquiv` that feeds it, exactly parallel to how
  `restrictScalarsRingIsoTensorEquiv` feeds `restrictScalars_isIso_μ`.

## C-PROBE VERDICT (SECONDARY, the iter-228 escalation tripwire input)

**C is DECISIVELY d.2-FREE — a genuine mirror of the CLOSED `tensorObj_restrict_iso`.**

The C-bridge `(dual M).restrict f ≅ dual (M.restrict f)` (open immersion `f`) follows the
IDENTICAL H1∘H2 architecture as `tensorObj_restrict_iso` (`:1822`), with `⊗` → `dual`:

  - **Step 1** `restrictFunctorIsoPullback` — reduce `restrict` → `pullback`. Reused verbatim.
  - **Step 2** `SheafOfModules.sheafificationCompPullback` — move pullback inside
    sheafification (both `dual M` and `tensorObj M N` are `sheafification.obj (presheaf-…)`,
    so this applies identically). Reused verbatim.
  - **Step 3** strip outer sheafification (`.mapIso`). Reused verbatim.
  - **Step 4** presheaf residual `(pullback φ).obj (PresheafOfModules.dual A)
    ≅ PresheafOfModules.dual ((pushforward β).obj A)`, closed by:
      • **H1** `pushforward β ≅ pullback φ` (`pushforwardPushforwardAdj` + `leftAdjointUniq`).
        Reused VERBATIM from `tensorObj_restrict_iso` (`:1872–1877`).
      • **H2′** the sectionwise commutation of `restrictScalars` along the open-immersion
        ring ISO `f.appIso` with the dual — this is `restrictScalarsRingIsoDualEquiv`
        (BUILT this iter, axiom-clean), the `Hom`-analogue of the tensor H2.

**Why no d.2:** the presheaf `dual A = internalHom A (𝟙_)` has sectionwise value the SLICE
hom-module `M|_U ⟶ R|_U` (over `Over U`). The comparison reduces to (a) the slice/`Over`
reindexing under the open immersion (structural object-level bookkeeping — the SAME kind
`restrict` already does, NOT a stalk) and (b) the ring-iso/Hom commutation (pure algebra,
`restrictScalarsRingIsoDualEquiv`). **No tensor stalk, no filtered-colimit-⊗, no `M ◁ η`
whiskering of the sheafification unit is ever invoked.** This is unlike the FORBIDDEN
sheafify-the-eval route (which composes the eval with `η` and re-hits `M ◁ η` = d.2).
`dual` is contravariant, but `restrictScalars` along a ring iso is an *equivalence*
(`restrictScalarsEquivalenceOfRingEquiv`), so it commutes with `Hom(-,-)` in both variances.

**DECISION SUPPORT:** the descent re-route is d.2-free on BOTH the A-front (gluing computes
no tensor stalk — `ts226descent` verdict D, confirmed by the landed B-connector) AND the
C-front (this probe). The remaining cost is bounded CATEGORY-THEORY ENGINEERING, not the
abandoned d.2 stalk-⊗ build. If the USER escalation weighs "continue vs lift RR pause", the
relevant fact is: **the route is mathematically sound and d.2-free; the blocker is build
SIZE, not a re-emergence of d.2.**

## `homOfLocalCompat` (A-bridge gluing engine) — NOT ADDED, precise blocker

- **Status:** NOT landed. NO sorry pinned (per FORBIDDEN constraint). Step (ii) IS landed
  as `homMk`; the remaining piece is step (i), the ab-sheaf morphism gluing.
- **The plan's "~30–60 LOC" estimate is UNREALISTIC.** Grounded assessment (full
  `Sites/SheafHom.lean` + `Modules/Sheaf.lean` API read, skeleton typechecked): the gluing
  engine is a **~120–190 LOC** build with several fiddly coherence steps. Decomposition
  (cleanest path found — `existsUnique_gluing` on the hom-sheaf, NOT the raw sieve route):

  0. **Primitive confirmed:** `presheafHom (M.val.presheaf) (N.val.presheaf)` is a sheaf of
     types via `Presheaf.IsSheaf.hom` (needs `N.isSheaf`), hence a `TopCat.Sheaf (Type u) X`.
     Gluing then via `TopCat.Sheaf.existsUnique_gluing` (`Type` has the needed
     `HasLimits`/`forget` instances). This AVOIDS the manual `FamilyOfElements`/sieve
     amalgamation of the raw `presheafHom_isSheafFor` route.
  1. **`localSection i : (presheafHom F G).obj (op (U i))`** from
     `f_i : M.restrict (U i).ι ⟶ N.restrict (U i).ι`. Skeleton typechecks. Component at
     `(V, h : V ⟶ U i) : Over (U i)` is `M.val.presheaf.obj (op V) ⟶ N.val.presheaf.obj (op V)`,
     built as `eqToHom ≫ (f_i.mapPresheaf).app (op (U i).ι ⁻¹ᵁ V) ≫ eqToHom` using the
     micro-lemma `(U i).ι ''ᵁ ((U i).ι ⁻¹ᵁ V) = V` for `V ≤ U i`
     (`Scheme.Hom.image_preimage_eq_opensRange_inf` + `Opens.opensRange_ι` + `inf_eq_right`).
     **BLOCKER:** the `naturality` field — commuting the eqToHom-conjugated `f_i` components
     across `Over (U i)` morphisms — needs `f_i.mapPresheaf`'s naturality + eqToHom coherence
     (`Over.map`/`Over.forget` interplay, à la `presheafHom`'s own `map_id`/`map_comp`). ~40–60 LOC.
  2. **`IsCompatible` (the cocycle)** of `{localSection i}` over `{U i}` — from the overlap
     hypothesis. ~30–50 LOC.
  3. **Glue + convert:** `existsUnique_gluing` gives `s : (presheafHom F G).obj (op ⊤)`;
     convert `s : (Over.forget ⊤).op ⋙ F ⟶ (Over.forget ⊤).op ⋙ G` to a genuine `F ⟶ G`
     (terminal-`Over` equivalence, or `presheafHomSectionsEquiv` via `sections ≃ obj(op ⊤)`
     since `op ⊤` is initial in `(Opens X)ᵒᵖ`). ~20–40 LOC.
  4. **Linearity + restriction-recovery:** feed the glued `g` to `homMk` (DONE this iter)
     after the sectionwise-linearity check; prove `(homMk …)` restricts to each `f_i`. ~20–40 LOC.

- **Next-iter recommendation:** build sub-piece (1) `localSection` (with its `naturality`)
  FIRST as its own axiom-clean lemma — it is the load-bearing translation and the only step
  with real coherence risk; (2)/(3)/(4) follow more mechanically once (1) lands. Do NOT pin a
  sorry. If (1)'s naturality proves intractable, the fallback is the raw
  `presheafHom_isSheafFor` route (also avoids d.2) but it is strictly more bookkeeping.

## Why I stopped — Partial progress (honest)

- **Real progress:** 3 axiom-clean declarations added — `homMk` (~L1986), `toPresheaf_map_homMk`
  (~L2002), `restrictScalarsRingIsoDualEquiv` (~L294) — PLUS a decisive C-probe verdict
  (d.2-free, with the axiom-clean `restrictScalarsRingIsoDualEquiv` as its Lean datapoint),
  PLUS the 3 comment-hygiene ride-along fixes.
- **The PRIMARY `homOfLocalCompat` did NOT fully land** — but NOT because of d.2. The gluing
  engine is a larger category-theory build than the plan estimated. I grounded the blocker in
  real API (skeleton typechecks; component constructible; the residual is the `naturality`
  coherence + cocycle + conversion). Per the FORBIDDEN constraint I pinned no sorry.
- **Escalation-tripwire framing:** the A-bridge proper not landing this iter DOES trip the
  mandate's A-front tripwire, but the cause is build SIZE, not d.2 re-emergence. The C-probe
  decisively clears the C-front (d.2-free). Net: the route is sound and d.2-free on both
  fronts; the live USER decision is purely "is the remaining bounded engineering worth it vs.
  lifting the RR pause for the divisor `Pic⁰` route".
- Approaches considered and NOT separately attempted to completion (documented, not silently
  skipped): manual section-by-section gluing of `g` via `N`'s sheaf condition (strictly more
  work than the `existsUnique_gluing` hom-sheaf route, same coherence hazards); the raw
  `presheafHom_isSheafFor` sieve route (more bookkeeping). The `existsUnique_gluing` route is
  the recommended one.

## Blueprint markers (for the review agent — do NOT set `\leanok` myself)
- `lem:sheafofmodules_hom_of_local_compat` (`homOfLocalCompat`): still a forward pin, NOT
  formalized — leave unmarked.
- No new blueprint pin exists for `homMk` / `toPresheaf_map_homMk` /
  `restrictScalarsRingIsoDualEquiv`; the plan/writer may wish to add a `\lean{}` pin for
  `restrictScalarsRingIsoDualEquiv` under `sec:tensorobj_dual_infra` (it is the C-build's H2′
  core, mirroring the pinned `restrictScalarsRingIsoTensorEquiv`).
