# Iter-182 prover briefings

## Lane A — `RiemannRoch/OCofP.lean` (scaffold `lineBundleAtClosedPoint` + `toFunctionField` bodies)

**Status**: substantive scaffold lane; analogist recipe in
`analogies/ocofp-sheaf-internalhom.md`. ETA per analogist: full body
~230-360 LOC, exceeds one-iter budget. Scope this iter is *partial
scaffold*: signature amend + carrier + presheaf bodies + sheaf-property
sorry; downstream consumers (`globalSections_iff` helpers,
`h1_vanishing_genusZero`, etc.) unchanged.

**Required actions**:

1. **Sig amend (allowed — non-protected)**: amend
   `lineBundleAtClosedPoint` signature (L140) to add
   `(hPcoh : Order.coheight P = 1)` per the analogist's Decision 3
   recipe. The existing `hP : IsClosed ({P} : Set C.left)` parameter
   stays. Update consumers in this file as needed (typed-sorry
   `toFunctionField` plus the 4 downstream lemmas — propagate the
   binder).

2. **Body scaffold** for `lineBundleAtClosedPoint`: implement
   per recipe in `analogies/ocofp-sheaf-internalhom.md` lines 158-203:
   - private def `lineBundleAtClosedPoint_carrier` (Submodule of K(C)
     defined by order conditions); ~30-50 LOC, may carry 1-2 internal
     named substantive sorries for `add_mem'` / `smul_mem'` if order
     superadditivity / scalar-invariance is not packaged in Mathlib.
   - private noncomputable def `lineBundleAtClosedPoint_presheaf`
     (functor `Opens.toCat ⟶ ModuleCat kbar` via `Submodule.inclusion`
     restriction); ~30-50 LOC.
   - private lemma `lineBundleAtClosedPoint_presheaf_isSheaf` — typed
     sorry, body iter-183+. Disclosure: this is the gluing-by-stalks
     content, ~100 LOC future.
   - `lineBundleAtClosedPoint` body: bundle as `⟨presheaf, isSheaf⟩`.

3. **Body scaffold** for `toFunctionField` (L154): per recipe — the
   inclusion `O_C(P) ↪ K_C` is the underlying inclusion-of-submodule
   composed with the constant-sheaf inclusion + global-section
   evaluation. ~50-80 LOC. May carry 1 typed-sorry on the `K_C`
   inclusion if the constant-sheaf gadget needs a project-side
   helper.

4. **Do NOT** attempt `globalSections_iff_mp` / `globalSections_iff_mpr`
   body closure this iter — gated on full `lineBundleAtClosedPoint` /
   `toFunctionField` bodies, which exceed budget.

**Helper budget**: 5 (carrier + presheaf + isSheaf-typed-sorry + 1-2
order-conditions sub-helpers).

**3-tier disclosure** required on each new decl. Use the iter-181
vocabulary: tier-1 kernel-clean (this body) / tier-2 kernel-clean
modulo upstream X / tier-3 direct sorry.

**Dead ends** documented in `analogies/ocofp-sheaf-internalhom.md`
Decisions 1, 4: do NOT pursue the `Hom_{O_C}(I_P, O_C)` abstract
internal-Hom route; do NOT open a new `IdealSheafDual.lean` file.

**Blueprint**: chapter `RiemannRoch_OCofP.tex`. The iter-182 plan-phase
writer added the `def:lineBundleAtClosedPoint_toFunctionField` pin per
iter-181 checker minor finding. Statement of `def:lineBundleAtClosedPoint`
is unchanged (this lane only adds an extra hypothesis — chapter prose
will catch up iter-183+).

---

## Lane B — `Genus0BaseObjects/GmScaling.lean` (cross01 body)

**Status**: recipe in `analogies/intersection-ring-cross01.md`
Decisions 2+3. Key finding: **Mathlib ships `Proj.pullbackAwayιIso`**
at `Mathlib/AlgebraicGeometry/ProjectiveSpectrum/Basic.lean:258-302`
with 5 companion `simp` lemmas. The iter-181 task_result's "build
project-side intersection-ring iso" plan is wrong — discard it. Use
the Mathlib iso directly.

**Required actions**:

1. **Project-side helper** `gmScalingP1_cover_intersection_X_iso`
   (~50-60 LOC): pullback iso for the intersection chart `X 0 * X 1`,
   uniform-in-`f` mirror of the existing `gmScalingP1_cover_X_iso`
   recipe but at the merged generator. Body uses
   `MvPolynomial.IsHomogeneous.mul` of the two `isHomogeneous_X` for
   the degree-2 witness, then the existing project recipe chain
   (`pullbackSymmetry ≪≫ pullbackRightPullbackFstIso ≪≫
   pullback.congrHom ...`).

2. **`gmScalingP1_chart_agreement_cross01` body** (L295, ~30-45 LOC):
   - `change pullback.fst _ _ ≫ ... = pullback.snd _ _ ≫ ...` at the
     pullback over the intersection chart.
   - Use `Proj.pullbackAwayιIso` to identify the inner pullback at
     Spec-level.
   - Apply `Proj.pullbackAwayιIso_hom_SpecMap_awayMap_left/right`
     and `pullbackAwayιIso_inv_fst/snd` to discharge the two sides
     against `Algebra.TensorProduct.tmul_mul_tmul` +
     `IsLocalization.Away.mul_invSelf`.

**Helper budget**: 2 (intersection-iso helper + 1 leeway for an
intermediate `awayMap` identification if needed).

**3-tier disclosure** on each new decl.

**Dead ends** documented in iter-181 Lane B task_result and the new
analogist: do NOT attempt `cancel_mono` on `(ProjectiveLineBar kbar).hom`
(not mono — structure map to `Spec k̄`); do NOT
attempt `unfold + simp` chain that's not anchored at
`Proj.pullbackAwayιIso`.

**Coordinate with Lane E** — both consume the same chart-1 section
infrastructure from `analogies/intersection-ring-cross01.md`
Decision 4.

**Blueprint**: chapter `AbelianVarietyRigidity.tex` (consolidated;
already documents the cross-case ring identity).

---

## Lane D — `Picard/RelativeSpec.lean` (`pullback_iso_construction` body)

**Status**: CONVERGING (iter-181 task_result has 5-helper recipe).
Per the progress-critic, proceed without analogist gate.

**Required actions**: close `pullback_iso_construction` body (L484-530)
per iter-181 task_result "Iter-182 pickup" Section:
1. Helper 3 (one-time hoist): introduce
   `noncomputable abbrev pullback_iso_functor` to expose
   `HasColimit` synthesis (bypasses the `let`-bound `d` typeclass
   blocker documented iter-181).
2. Helper 4: forward map via `glueMorphismsOfLocallyDirected`
   (template: `f.toNormalization` at
   `Mathlib/AlgebraicGeometry/Normalization.lean:136-155`).
3. Helper 5: backward map via `colimit.desc` + naturality chase.
4. Helper 6: `Iso.mk fwd bwd hom_inv_id inv_hom_id` assembly.
5. Helpers 7, 8: close the two inverse laws via cover-local checks
   (the `RelativeGluingData.glued`-level identities).

Alternative shortcut documented iter-181: `IsColimit.coconePointUniqueUpToIso`
with `AffineZariskiSite.isColimitCocone` may collapse 2-3 helpers
into 1. Explore if budget allows.

**Helper budget**: 5 (5-helper recipe is the worst case; the shortcut
collapses to 3).

**3-tier disclosure** on each. The expected outcome is the
`pullback_iso_construction` body closing kernel-clean (this body)
or kernel-clean modulo 1-2 named substantive helpers (the inverse
laws are the most likely substantive sorries).

**Dead end** documented: do NOT inline `letI d := ...` —
typeclass synthesis fails for `HasColimit d.functor`. Must use the
top-level abbrev (Helper 3).

**Blueprint**: chapter `Picard_RelativeSpec.tex`. iter-181 task_result
noted the chapter prose could lift Lane D Lean docstring into a
dedicated `\lemma{pullback_iso_construction}` block (iter-183 if you
notice the gap; not iter-182 work).

---

## Lane E — `AbelianVarietyRigidity.lean` (`iotaGm_range_isOpen` body)

**Status**: recipe in `analogies/intersection-ring-cross01.md`
Decision 4. Coordinated with Lane B (same chart-1 section
infrastructure).

**Required actions**: close `iotaGm_range_isOpen` body (L98+) per
analogist Decision 4:

1. Extract the chart-1 section `r_1 : Spec k̄ ⟶ Spec(Away 𝒜 (X 1))`
   via `Proj.fromOfGlobalSections_morphismRestrict` on the chart-1
   basic open (the analogist cites this as the Mathlib factorization
   lemma; verify via `lean_local_search` if needed).
2. Build `s : Gm.left ⟶ (cover).X 1` via `pullback.lift` of
   `(toUnit Gm ≫ onePt).left ≫ r_1.inv` and `(𝟙 Gm.left)` (with the
   over-structure compatibility witness from the natural setup).
3. Use `Cover.ι_glueMorphisms` to identify
   `s ≫ (cover).f 1 ≫ gmScalingP1.left`.
4. Apply `IsOpenImmersion.isOpen_range` on `Proj.awayι` (an
   `IsOpenImmersion` instance per
   `Mathlib/AlgebraicGeometry/ProjectiveSpectrum/Basic.lean:196`) +
   `Set.range` chain.

ETA ~45-60 LOC per analogist.

**Helper budget**: 2 (the section `s` may be a named helper; or
inline).

**3-tier disclosure** on the body. Expected outcome: body
kernel-clean (this body) modulo the `s` section if extracted as
helper; otherwise inline kernel-clean.

**Dead ends** documented: do NOT attempt `IsOpenImmersion.isDominant`
(does not exist, iter-178 dead-end); do NOT try to make
`gmScalingP1` itself surjective then derive — composition of dense +
surjective with arbitrary morphism is not dense in general.

**Coordinate with Lane B** — same chart-1 unfold work; helpers may
be shared if both lanes land in the same iter (consider extracting
to a shared private helper in `GmScaling.lean` if budget allows).

**Blueprint**: chapter `AbelianVarietyRigidity.tex` (consolidated).
NOTE block at L1912-1918 (iter-167) is unchanged.

---

## Lane F — `Picard/QuotScheme.lean` PIVOT (typed-sorry helper)

**Status**: per `analogies/quotscheme-pullback-affine-section.md`,
the iter-181 strategy ("decompose more") is wrong. PIVOT: create a
single new named typed-sorry def
`Scheme.Modules.pullback_app_isoTensor` (the missing affine-open
section formula for `Scheme.Modules.pullback`); collapse the iter-181
2-helper substantive split's bodies through it.

**Required actions**:

1. Add new `noncomputable def Scheme.Modules.pullback_app_isoTensor`
   (typed sorry; signature per analogist recipe Section X). This is
   the LOAD-BEARING gap: for `g : S' ⟶ S` flat, `N : S.Modules`, and
   affine `U : S'.Opens`,
   `Γ((Scheme.Modules.pullback g).obj N, U) ≅ Γ(S', U) ⊗_{Γ(S,V)} Γ(N, V)`.
   ETA ~120-200 LOC body iter-183+. THIS iter: just the typed-sorry
   signature.

2. **Collapse iter-181 helpers through it**: rewrite
   `canonicalBaseChangeMap_app_app_isIso_of_isAffineOpen_of_isAffineBase`
   body (currently a typed sorry) to consume `pullback_app_isoTensor`
   + `Module.Flat.isBaseChange` — this should be a ~15-25 LOC closure
   per analogist's "Module.Flat.isBaseChange consumer-side packaging"
   recipe.

3. The main `canonicalBaseChangeMap_app_app_isIso_of_isAffineOpen`
   body (Mayer-Vietoris reduction) may remain typed-sorry this iter —
   it's a separate substantive piece.

**Helper budget**: 1 (the new `pullback_app_isoTensor` typed-sorry def).

**3-tier disclosure** on each. Expected: the iter-181 `_of_isAffineBase`
helper closes kernel-clean modulo the new `pullback_app_isoTensor`
typed sorry. Net file sorry count: +1 (new typed-sorry def) −0 (no
closures yet); the iter-181 substantive helper sorry remains but is
now visible-as-named-substantive-pin.

**Dead ends** documented: do NOT decompose `_of_isAffineBase` further
without the typed-sorry def in place — the iter-180+181 "decompose
more" attempts churned 4 helpers, +1 net sorry, over 2 iters.

**Blueprint**: chapter `Picard_QuotScheme.tex`. iter-181 checker
recommended 4 missing pins; this lane's `pullback_app_isoTensor` adds
a 5th pin candidate (iter-183 blueprint-writer scope).

---

## Lane G — `Albanese/AuslanderBuchsbaum.lean` PIVOT to `depth_of_short_exact`

**Status**: per `analogies/isregularlocalring-isdomain.md`,
`exists_isRegular_of_regularLocal` (the iter-181 Lane G target) needs
~300 LOC project-side build via Stacks 00NQ. NOT iter-182 work. PIVOT
to `depth_of_short_exact` (L268) — Stacks 00LE, less Mathlib-gap
exposure.

**Required actions**: close `depth_of_short_exact` body per Stacks
00LE: given `0 → M' → M → M'' → 0` SES in `R-Mod` and `I : Ideal R`:
- `depth_{I}(M) ≥ min(depth_{I}(M'), depth_{I}(M''))`
- `depth_{I}(M') ≥ min(depth_{I}(M), depth_{I}(M'') + 1)`
- `depth_{I}(M'') ≥ min(depth_{I}(M) - 1, depth_{I}(M'))`

Per the iter-180 Lane H success closing `Module.depth` body
kernel-clean via Stacks 00LF supremum form, the depth API is
unblocked structurally.

Proof route: induction on the inequality bound via the long exact
sequence of `Ext^*(R/I, ·)` applied to the SES.

ETA ~80-120 LOC.

**Helper budget**: 2 (for the LES-of-Ext fragments if needed).

**3-tier disclosure** on body. Expected: kernel-clean (this body) if
the Mathlib LES API is in scope; else kernel-clean modulo 1 named
LES-fragment sorry.

**Dead ends** documented: do NOT attempt `exists_isRegular_of_regularLocal`
body this iter (per analogist; needs ~300 LOC); do NOT attempt
`auslander_buchsbaum_formula` body this iter (Stacks 090V; multi-iter
substrate).

**Blueprint**: chapter `Albanese_AuslanderBuchsbaum.tex`. iter-180
writer landed the depth API documentation; the SES additivity
content is in the chapter's "depth axioms" section.

---

## Lane I — `RiemannRoch/RationalCurveIso.lean` Pin 2 BODY (post-refactor)

**Status**: CRITICAL per progress-critic — must combine signature
refactor AND body in the SAME iter, breaking the 3-consecutive-iter
signature-only avoidance pattern. iter-182 plan-phase `refactor
pin2-sig-strengthen` LANDED the signature change; this Lane closes
the body.

**Required actions**: close `morphism_degree_via_pole_divisor` body
(post-refactor L320) per `analogies/ratcurveiso-pin2.md` body recipe:

1. The new signature output asserts:
   `∃ D, D = Scheme.Hom.poleDivisor φ ∧ D.degree = Module.finrank K(ℙ¹) K(C)`
2. Witness: `D := Scheme.Hom.poleDivisor φ`. The equality
   `D = poleDivisor φ` is `rfl`.
3. The degree identity reduces to
   `(poleDivisor φ).degree = Module.finrank K(ℙ¹) K(C)`
   which requires the body of `poleDivisor` itself (typed-sorry at
   L290 added iter-182 plan-phase). DEFER to iter-183.

   ALTERNATIVELY: defer the degree identity behind a single named
   helper sorry `Scheme.Hom.poleDivisor_degree_eq_finrank` (the
   project's `analogies/ratcurveiso-pin2.md` recipe's `Ideal.sum_ramification_inertia`
   body). This unblocks the lane's structural progress.

4. The `Scheme.Hom.poleDivisor` body itself (typed-sorry):
   per analogist Decision 2 + 3 recipe, ETA ~80-150 LOC using
   `Ideal.sum_ramification_inertia` + affine-chart Dedekind-domain
   bridge. DEFER to iter-183 (out of scope for this iter; this
   iter the Lane I closes the wrapper via a named helper).

**Acceptable lane outcome shapes**:
- **SUCCESS**: Pin 2 body kernel-clean modulo `poleDivisor` body
  (which remains typed-sorry). The wrapper structure lands.
- **SUCCESS with helper**: Pin 2 body kernel-clean modulo
  `poleDivisor_degree_eq_finrank` named helper (the substantive
  degree identity), separated cleanly from `poleDivisor` itself.

Either shape breaks the iter-182 signature-only pattern.

**Helper budget**: 3 (poleDivisor + degree identity + 1 leeway for
the `Algebra K(ℙ¹) K(C)` instance threading at the call site if
needed).

**3-tier disclosure** on each. Expected: Pin 2 wrapper closes
structurally; `poleDivisor` typed-sorry remains; degree identity
either inline or named.

**Dead ends** documented: do NOT attempt the affine-chart
`Ideal.sum_ramification_inertia` calculation INLINE in Pin 2 — it's
~80-150 LOC and exceeds budget; do NOT close `poleDivisor` body
this iter.

**Blueprint**: chapter `RiemannRoch_RationalCurveIso.tex`. iter-182
plan-phase writer updated `lem:degree_via_pole_divisor` block to
bind `D = φ^*[∞]` and reference `Scheme.Hom.poleDivisor`.

---

## Off-lane: chart writer's recommendation

The iter-182 plan-phase blueprint-writer for OcOfD chapter `LANDED`
(see PROGRESS.md). The Lean file `RiemannRoch/OcOfD.lean` is NOT
opened this iter (the iter-181 RoboBudget reasoning: 1-iter latency
for the same-iter fast path's blueprint-reviewer dispatch is
acceptable). iter-183 plan-phase will dispatch a mandatory
blueprint-reviewer + iter-183 prover phase opens `OcOfD.lean` as a
file-skeleton lane per the iter-182 chapter.

**Rebuttal to progress-critic must-fix on OcOfD**: the chapter
LANDED this iter; the file opens iter-183. Net 1-iter latency cost,
within tolerance. The 5-iter deferral pattern the critic flagged is
explicitly broken (chapter now exists; file-skeleton is iter-183
mechanical).
