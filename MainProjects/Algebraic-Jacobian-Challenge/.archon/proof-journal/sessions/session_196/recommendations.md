# Iter-196 → Iter-197 Recommendations

## CRITICAL / HIGH (act this iter)

### CRIT-0b — Blueprint BareScheme must-fix (1 must-fix + 2 major; HARD GATE on BareScheme.lean for iter-197 — same chapter as CRIT-0a)

The lean-vs-blueprint-checker for BareScheme returned **1 must-fix-this-iter**
finding + 2 major. Because BareScheme.lean is covered by the consolidated
`AbelianVarietyRigidity.tex` chapter (per its `% archon:covers` declaration),
the HARD GATE applies to BareScheme.lean alongside AVR.lean (CRIT-0a). Plan
agent: roll these items into the same `blueprint-writer avr-iter196-mustfix`
dispatch as CRIT-0a:

1. **[must-fix]** Expand `lem:projectiveLineBar_geomIrred` (AVR.tex L972-993)
   with an explicit Lean recipe: state **Helper A**
   (`Proj 𝒜 ⊗ K ≅ Proj 𝒜 ×_S Spec K`, i.e. the `Proj.base_change` or
   equivalent isomorphism — the load-bearing 200-350 LOC substrate gap),
   plus **Helpers B-E** fleshing out integral-domain + base-change + geometric
   irreducibility chain. The current informal prose is insufficient for a
   prover to close the L218 sorry; the expanded recipe gives prover targets.

2. **[major]** Add a dedicated `\lean{AlgebraicGeometry.projectiveLineBar_isProper}`
   block for the properness instance with brief proof sketch (bijectivity-of-
   algebraMap argument + `Proj.instIsProperToSpecZero` chain).

3. **[major]** Add a `\lean{...}` block for
   `mvPolynomialFin_isStandardSmoothOfRelativeDimension` (as a `\mathlibok`-
   candidate sub-lemma of `lem:projectiveLineBar_smoothOfRelDim`). Prose
   should note: (a) Mathlib does not ship a direct
   `IsStandardSmoothOfRelativeDimension n R (MvPolynomial (Fin n) R)` instance;
   (b) project builds it via the 5-declaration `Algebra.SubmersivePresentation`
   chain (`mvPolyGenerators → mvPolyPresentation →
   mvPolyPreSubmersivePresentation → mvPolySubmersivePresentation →
   mvPolynomialFin_isStandardSmoothOfRelativeDimension`); (c) chain terminates
   in `Algebra.SubmersivePresentation.isStandardSmoothOfRelativeDimension` with
   dimension count `Nat.card (Fin n) - Nat.card PEmpty = n`. This is a
   Mathlib upstream PR candidate; documenting it in the blueprint preserves
   the project-side substrate finding.

Minor (deferrable to optional iter-197+):
- Blueprint smoothness sketch names `Smooth_iff_atOpens` but Lean uses
  `IsZariskiLocalAtSource.of_openCover` — loose hint, optional refresh.
- Per-chart sorry's dependency on ChartIso not acknowledged in
  `lem:projectiveLineBar_smoothOfRelDim` sketch — optional sentence.

Reference: `logs/iter-196/lean-vs-blueprint-checker-barescheme-report.md`.

### CRIT-0a — Blueprint AVR must-fix (1 must-fix + 4 major; HARD GATE on AbelianVarietyRigidity.lean for iter-197)

The lean-vs-blueprint-checker for AVR returned **1 must-fix-this-iter**
finding plus 4 major findings. Per the HARD GATE rule, **AbelianVarietyRigidity.lean
is gated from prover re-dispatch until the blueprint chapter is updated**.
Plan agent MUST dispatch ONE `blueprint-writer` slug `avr-iter196-mustfix`
covering ALL of these before any new Lane E prover work:

1. **[must-fix]** Add a `\begin{lemma}...\end{lemma}` block for
   `Proj.basicOpenIsoSpec_inv_app_top` with a `\lean{...}` pin. This is the
   iter-197 prescribed workaround for the `Scheme.Hom.app` dependent-motive
   issue (CRIT-1 above). Statement:
   ```
   (Proj.basicOpenIsoSpec 𝒜 f f_deg hm).inv.app ⊤ =
     (Proj.basicOpen 𝒜 f).topIso.hom ≫
     (Proj.basicOpenIsoAway 𝒜 f f_deg hm).inv ≫
     (Scheme.ΓSpecIso _).inv
   ```
   Proof sketch: `Scheme.inv_app` + `Proj.basicOpenIsoSpec_hom` +
   `Proj.basicOpenToSpec_app_top` + iso inversion. ~5-15 LOC. This block
   becomes the substrate the iter-197 prover targets directly.

2. **[major]** Update Step 1 of the `lem:awayi_app_basicOpen` proof sketch:
   currently references the non-existent `Proj.awayι_eq_isoSpec_ι_comp`;
   should reference the landed `Proj.awayι_eq_specMap_fromSpec` instead.
   The updated approach: `rw [Proj.awayι_eq_specMap_fromSpec]` → `comp_app`
   split into `fromSpec.app ⊤` and `Spec.map(basicOpenIsoAway.inv).app _`.
   (This also explains the dependent-motive issue — both sides of the
   factorization have the same app-codomain type, sidestepping the rewrite
   block iter-196 hit.)

3. **[major]** Add a `\lean{AlgebraicGeometry.Proj.awayι_eq_specMap_fromSpec}`
   block for the iter-196 landed morphism-level factorization. Statement:
   `Proj.awayι 𝒜 f f_deg hm = Spec.map (basicOpenIsoAway _).inv ≫ (isAffineOpen_basicOpen _).fromSpec`.

4. **[major]** Add a `\lean{AlgebraicGeometry.Proj.awayι_preimage_basicOpen_self}`
   block for the iter-196 landed preimage identity. Brief statement.

The two future targets the blueprint currently pins
(`Proj.awayι_app_basicOpen`, `Proj.awayι_appIso_top_inv_apply_isLocElem`)
should be retained as iter-197 closure targets — they consume the new
`Proj.basicOpenIsoSpec_inv_app_top` substrate.

Reference: `logs/iter-196/lean-vs-blueprint-checker-avr-report.md`.

### CRIT-0 — Blueprint H1V must-fix (3 findings; HARD GATE on H1Vanishing.lean for iter-197)

The lean-vs-blueprint-checker for H1V returned **3 must-fix-this-iter
findings**, all chapter-side. Per the HARD GATE rule in `.archon/CLAUDE.md`,
**H1Vanishing.lean is gated from prover re-dispatch until the blueprint
chapter is updated**. Plan agent MUST dispatch ONE `blueprint-writer` slug
`h1v-iter196-mustfix` covering ALL three before any new Lane H prover work:

1. **`lem:isFlasque_constant_irreducible` proof sketch** (blueprint
   `RiemannRoch_H1Vanishing.tex` proof block ~L171-182): the non-empty
   branch is described as immediate ("restriction map is the identity on
   A — in particular surjective"). The Lean code requires the
   `constantSheaf` sheafification-unit-iso on irreducible spaces, which
   Mathlib `b80f227` does not ship. Action: add a `% NOTE` acknowledging
   the Mathlib gap + describing the closure strategy (Sheaf.IsConstant
   framework / explicit sheafification computation; ~100-200 LOC
   standalone).
2. **`lem:skyscraperSheaf_eq_pushforward` proof sketch** (~L424-437): the
   sketch describes a pointwise presheaf-level argument but does NOT
   describe the inner iso (`skyscraperSheaf PUnit.unit A ≅ (constantSheaf
   J_punit).obj A`) that is the blocking technical step in the Lean proof.
   The Lean signature is `Nonempty (skyscraperSheaf P A ≅ ...)`, weaker
   than the blueprint's claim "naturally isomorphic". Action: add a
   `% NOTE` describing the inner iso as the blocking sub-step AND the
   `Nonempty` weakening (note that the inner iso needs
   `(constantSheaf (Opens.grothendieckTopology PUnit) D).Full` +
   `.Faithful` instances on PUnit — Mathlib upstream candidate). Decide
   whether to accept the `Nonempty` weakening in the blueprint or require
   the Lean signature to strengthen — recommend accepting (no consumers
   currently need the actual iso morphism).
3. **`lem:skyscraperSheaf_isFlasque` `\uses{...}` list**: the blueprint
   pins 4 sub-lemmas including `lem:skyscraperSheaf_eq_pushforward` and
   `lem:isFlasque_constant_irreducible`, but the Lean proof uses NONE of
   them — it goes directly via `skyscraperPresheaf_map` on both branches
   of the `P.point ∈ V` case split. Action: remove the stale
   `\uses{lem:skyscraperSheaf_eq_pushforward, lem:isFlasque_constant_irreducible, ...}`
   entries. This is needed to clean up the dependency graph since both
   listed deps still carry sorrys.

Also major (not must-fix but should be addressed in the same dispatch):

- Add `\lean{AlgebraicGeometry.Scheme.IsFlasque.injective_flasque}` pin
  under `thm:H1_vanishing_flasque` as a `\uses{}` substrate so
  `sync_leanok` tracks the carrier sorry independently from the headline
  theorem (currently `\leanok` on the headline overstates closure given
  the transitive `injective_flasque` sorry).
- Optional pins for `ext_one_eq_zero_of_hom_surjective_of_injective`,
  `shortExact_app_surjective` (substantive iter-194/195 helpers without
  blueprint coverage).

Reference: `logs/iter-196/lean-vs-blueprint-checker-h1v-report.md`.

### CRIT-1 — Lane E iter-197 prescription is concrete; 25-45 LOC closure of 2 sorries

The iter-196 prover landed 2 of 3 substrate primitives from the
`lane-e-proj-appiso-pivot` blueprint recipe axiom-clean
(`Proj.awayι_preimage_basicOpen_self`, `Proj.awayι_eq_specMap_fromSpec` at
~L189, ~L199 of `AbelianVarietyRigidity.lean`). The remaining work for
iter-197:

1. Build `Proj.basicOpenIsoSpec_inv_app_top` via `Scheme.inv_app` +
   `basicOpenToSpec_app_top` (~5-15 LOC). This is the workaround for the
   `Scheme.Hom.app` dependent-motive issue that blocked the direct
   `rw [Proj.awayι_eq_specMap_fromSpec]` route.
2. Close `Proj.awayι_app_basicOpen` via `change` to unfold `awayι` +
   `Scheme.Hom.comp_app` split + `Scheme.Opens.ι_app` +
   `basicOpenIsoSpec_inv_app_top` (~10-15 LOC).
3. Close `Proj.awayι_appIso_top_inv_apply_isLocElem` via
   `Scheme.Hom.appIso_inv_app` + `awayToSection_apply` +
   `awayι_app_basicOpen` (~5-10 LOC).
4. Drop into the two Lane E consumer sorries:
   - `kbarChart1Ring_specMap_fac` at L326 (~5-15 LOC, follows the iter-196
     prover's documented recipe in task result).
   - `iotaGm_chart1_appIso_eval` at ~L534 (~5-15 LOC modulo the iso-chain
     functoriality stages 5–8 in the existing proof body).

**Total: ~25-45 LOC, 2 sorries closed.** This is the highest-leverage and
most-prescribed closure path going into iter-197. Plan agent should dispatch
a Lane E prover with this exact recipe (mode `prove`, helper budget 3, scope
restricted to AVR.lean).

### CRIT-2 — Lane BareScheme smoothness closure needs a refactor relocating the instance downstream

`projectiveLineBar_smoothOfRelDim` (BareScheme.lean L325) cannot be closed in
BareScheme.lean itself because `homogeneousLocalizationAwayIso` lives in
`ChartIso.lean` (downstream of BareScheme.lean in the import graph). The
iter-196 prover documented two options:

- **Option (a) — RECOMMENDED**: dispatch a `refactor` subagent to relocate
  `projectiveLineBar_smoothOfRelDim` to a downstream file (either
  `Genus0BaseObjects/ChartIso.lean` itself, or a new `Genus0BaseObjects/Smooth.lean`).
  The 5 MvPolynomial Submersive substrate decls (`mvPolyGenerators`,
  `mvPolyPresentation`, `mvPolyPreSubmersivePresentation`,
  `mvPolySubmersivePresentation`,
  `mvPolynomialFin_isStandardSmoothOfRelativeDimension`) STAY in BareScheme
  as Mathlib supplement; only the project-specific instance moves. Final
  closure ~10 LOC via `Algebra.IsStandardSmoothOfRelativeDimension.of_algEquiv`.
- **Option (b) — REJECTED**: duplicate the iso (~80+ LOC).

Plan agent: dispatch `refactor` slug `relocate-projlinebar-smoothofreldim`
this iter; then a prover lane closes the residual.

### CRIT-3 — Blueprint OCofP fixes (3 major + 1 minor from blueprint-checker + 1 doctor finding)

The blueprint-checker for OCofP returned with 3 MAJOR findings (no
must-fix-this-iter, but all chapter-side housekeeping). The blueprint
doctor flagged the same broken `\uses` independently. Plan agent should
dispatch ONE `blueprint-writer` slug `ocofp-iter196-fixes` covering all
of these:

1. **Move `\leanok` out of `\uses{...}` arg** at blueprint lines 692-695
   (the proof block of `lem:lineBundleAtClosedPoint_toFunctionField_injective`).
   The token leaked mid-argument; the label
   `def:lineBundleAtClosedPoint_carrierSubmoduleSheaf` exists correctly
   at blueprint line 158 — this is a formatting bug, not a missing label.
   Fix per checker recommendation:
   ```
   \begin{proof}
     \uses{lem:lineBundleAtClosedPoint_globalSections_iff,
           def:lineBundleAtClosedPoint_carrierSubmoduleSheaf}
     \leanok
     The map ...
   ```
2. **Update `lem:lineBundleAtClosedPoint_order_conditions_of_globalSection`**
   (blueprint L775): the `\lean{...}` pin targets a Lean declaration that
   doesn't exist — the iter-196 prover left the content inlined in
   `exists_nonconstant_rational_from_dim_eq_two` (L1594-1595). Options:
   (a) extract a standalone Lean declaration (~10 LOC) — but this requires
   a future prover dispatch, not the blueprint-writer; OR
   (b) update the blueprint to remove the `\lean{...}` pin and reference
   the inlined step via a `% NOTE` comment. **Recommended (b)** for the
   blueprint-writer; the prover-side extraction is optional polish.
3. **Update `lem:lineBundleAtClosedPoint_principal_ne_zero_of_nonconstant`**
   (blueprint L827): the `\lean{...}` pin targets
   `AlgebraicGeometry.Scheme.WeilDivisor.principal_ne_zero_of_nonconstant`
   which doesn't exist. The Mathlib-gap substep WAS extracted as
   `functionField_const_of_complete_curve_of_orderZero` (different name).
   Options:
   (a) extract the outer lemma (gated on the substrate sorry) — requires a
   future prover dispatch; OR
   (b) update the blueprint `\lean{...}` to reference the actually-extracted
   helper + note the outer lemma is still inlined. **Recommended (b)**.

Minor: `carrierPresheaf`, `carrierPresheaf_isSheaf`, `carrierSubmoduleSheaf`
are `private` Lean declarations but `\lean{...}`-pinned in the blueprint.
This is a stylistic concern — not strictly broken (the names still resolve
via fully-qualified path in Lean). Plan agent: optional fix.

Reference: `logs/iter-196/lean-vs-blueprint-checker-ocofp-report.md`.

### CRIT-4 — Carrier-soundness probe: run `lean_verify` smoke check this iter (now with auditor-confirmed co-dependency)

The iter-196 plan-phase `carrier-soundness-fgapic` refactor landed 6 carriers
in the `Functor.IsRepresentable` / typeclass + `Classical.choice` pattern.
The 2-3 iter abort criterion mandates verification at iter-197/198: dispatch
a prover lane or run `lean_verify` directly on:

- `AlgebraicGeometry.Scheme.PicScheme`
- `AlgebraicGeometry.Scheme.PicScheme.representable`
- `AlgebraicGeometry.Scheme.PicSharp`
- `AlgebraicGeometry.Scheme.divFunctor`
- `AlgebraicGeometry.Scheme.abelMap`
- `AlgebraicGeometry.Scheme.groupSchemeStructure`

Expected: `sorryAx` appears only through explicit `instHasPicScheme` /
`instPicSharpRepresentable` chains (auditable via the dependency trace).
Silent typeclass-synthesis sorryAx would be the abort signal.

**Iter-196 lean-auditor M1 finding (raised severity)**: The carrier-soundness
refactor introduced an additional 7th sorry instance — `instHasPicScheme :
HasPicScheme C := ⟨sorry⟩` — whose `has_pic_scheme` field has type
`Nonempty (∃ X, (PicScheme.picSharp C).RepresentableBy X)`. Since
`PicScheme.picSharp C = Classical.choice HasPicSharp.has_pic_sharp`, the term
requires `[HasPicSharp C]` to elaborate, **triggering the
co-dependency chain `HasPicScheme → HasPicSharp`**. A consumer writing only
`[HasPicScheme C]` silently inherits `sorryAx` from BOTH instances. Both are
named (traceable via `lean_verify`), but the chain is invisible at the
consumer's declaration site. **Specific iter-197 action**: run `lean_verify`
on a concrete consumer (e.g. `PicScheme.representable`) and inspect whether
`sorryAx` appears from both `instHasPicScheme` AND `instHasPicSharp`. If
confirmed, consider whether (a) `picSharp` should be defined outside the
`HasPicSharp` class body to break the synthesis cycle, or (b) consumer sites
should `haveI := instHasPicSharp C` explicitly to make the chain visible.
Also: add a `-- ⚠ co-depends on instHasPicSharp` annotation to the
`instHasPicScheme` body for reader-visible discoverability (lean-auditor
minor m1).

## MEDIUM

### MED-1 — Lane I named residual `hy_ne_bot` is 5-10 LOC away

The iter-196 Route 2 PID-transfer body decomposition reduced the
`isRegularInCodimOneProjectiveLineBar` (WeilDivisor.lean L750) sorry to a
single named residual `hy_ne_bot : y.asIdeal ≠ ⊥` (Stacks 02IZ/005X
topological-coheight ↔ algebraic-prime-non-zero bridge). Closure:

1. Stacks 02IZ: open immersion preserves coheight at points within its image
   (Mathlib `Scheme.IsOpenImmersion.coheight_eq` or similar — verify).
2. Stacks 005X: in a 1-dim integral affine scheme (= `Spec(k̄[t])`), coheight-1
   points are maximal ideals.
3. Maximal ideals are non-zero (trivial in a non-field).

If Mathlib's `Scheme.IsOpenImmersion.coheight_eq` exists, total ~5-10 LOC. If
not, ~30-60 LOC project-side helper. Plan agent: dispatch Lane I prover slug
`hy-ne-bot` with mode `prove`, helper budget 2.

### MED-2 — Lane A iter-197+ closure path for `functionField_const_of_complete_curve_of_orderZero`

The iter-196 prover extracted the Stacks 02P0 / Hartshorne I.3.4 gap into a
named substrate helper. iter-197+ closure (~80-150 LOC):

- **Sub-helper (i)**: algebraic Hartogs at codim-1 — Γ(C, 𝒪_C) =
  ⋂_{Q codim 1} 𝒪_{C, Q} for normal Noetherian scheme. Project-bespoke;
  combines Mathlib's `Subalgebra.toSubmonoid` API with the DVR-stalk
  identification from `IsRegularInCodimensionOne`.
- **Sub-helper (ii)**: Γ(C, 𝒪_C) = k̄ for proper geom-irred curves over
  alg-closed k̄. Combines `Module.Finite k̄ Γ` (Hartshorne III.5.2 cohomology)
  + the alg-closure argument (every element root of a polynomial ⟹ in k̄)
  + `IrreducibleSpace.connectedSpace`.

Plan agent: defer to iter-198+; iter-197 should prioritize Lane E (CRIT-1)
and Lane I `hy_ne_bot` (MED-1) for net sorry decrease.

### MED-3 — Lane H non-empty branches need new Mathlib substrate

Both Lane H residuals need Mathlib b80f227 infrastructure absent:

- **`IsFlasque.constant_of_irreducible` non-empty branch**:
  `(constantSheaf J D).Full` + `.Faithful` instance for irreducible spaces
  (Mathlib upstream candidate; ~30-50 LOC) OR alternate-sheaf construction
  (~100-200 LOC project-side).
- **`skyscraperSheaf_eq_pushforward_const` inner iso**:
  `(constantSheaf (Opens.grothendieckTopology PUnit) D).Full` + `.Faithful`
  on PUnit (Mathlib upstream candidate; ~30-50 LOC) OR
  `NatIso.ofComponents` pointwise on ⊥/⊤ (~50-80 LOC project-side).

Plan agent: consider deferring to a multi-iter Lane H-substrate sub-lane;
iter-197 prioritize the closer-to-closure lanes.

### MED-4 — Lane RCI generic-point branch is closable iter-197

Per iter-196 prover task result: with the reformulated `Set.Finite` goal,
the generic-point branch (`x = genericPoint C'.left`) is closable via
`genericPoint_eq` functoriality + the iter-194
`phi_left_functionField_algEquiv_of_finrank_one` substrate. ~20-30 LOC.
Plan agent: dispatch Lane RCI prover slug `generic-point-branch` this iter
(closed-point branch remains substrate-gated on smooth-dim-1 ⟹ 0-dim fibre).

## LOW

- **LOW-1**: Lane I `degree_positivePart_principal_eq_finrank` body remains
  blocked on Hartshorne I.6.12 function-field correspondence
  (`Scheme.Hom.ofFunctionFieldEmbedding`). Off-iter-197 critical path.
- **LOW-2**: Lane I `principal_degree_zero` non-constant branch and
  `rationalMap_order_finite_support` f≠0 branch — same Mathlib gap as LOW-1.
- **LOW-3**: Lane H `IsFlasque.injective_flasque` (L613) — out-of-scope
  per iter-196 progress-critic; consumer `HModule_flasque_eq_zero` is gated.
  Re-evaluate iter-198+.

## Reusable proof patterns (add to PROJECT_STATUS.md Knowledge Base)

- **`Algebra.SubmersivePresentation` 0×0 Jacobian for MvPolynomial**:
  closes `Algebra.IsStandardSmoothOfRelativeDimension n R (MvPolynomial (Fin n) R)`
  via `Algebra.Generators.ofSurjective` + empty Presentation + 0×0 Jacobian
  determinant = 1. Mathlib supplement, ~50 LOC; previously thought to be a
  Mathlib gap (iter-182), now closeable purely from existing Mathlib API.
- **`IsZariskiLocalAtSource.of_openCover` cover-reduction recipe**: discharges
  `P f` from `∀ i, P (𝒰.f i ≫ f)` for any property `P` with
  `IsZariskiLocalAtSource P`. Pattern used to reduce
  `SmoothOfRelativeDimension` to per-chart smoothness via the affine cover.
- **`ObjectProperty.FullSubcategory.ext` for sheaf equalities**: lifts a
  presheaf-level equality to a sheaf-level equality whenever both sides have
  the `IsSheaf` property (the `IsSheaf` Prop-valued field is
  subsingleton-equal). Used in iter-196 Lane H to lift
  `skyscraperPresheaf_eq_pushforward` from presheaves to sheaves.
- **`LocallyQuasiFinite.of_finite_preimage_singleton` as LQF reformulation
  recipe**: when stuck on abstract per-fibre LQF goals, reformulate via this
  Mathlib lemma (requires `[LocallyOfFiniteType φ]` + `∀ x, (φ ⁻¹' {x}).Finite`).
  Converts opaque fibre-LQF to concrete topological preimage-finiteness.
- **`congrArg`-style rewriting on `Scheme.Hom.app` is BLOCKED by
  dependent motive**: any attempt to `rw [f_eq_g]` under
  `Scheme.Hom.app f V` fails because `app`'s codomain `Γ(X, f⁻¹ᵁ V)` changes
  when `f` changes shape. Workaround: build an `appTop`-level helper (or
  `app U` helper for the specific U), then chain through `comp_app`. Pattern
  identified iter-196 Lane E; carries forward as named obstacle for similar
  reformulations across the project.
- **Demote `private instance ... := sorry` to `private theorem ... := sorry`
  to break silent sorryAx propagation**: pattern used by iter-196 plan-phase
  `must-fix-demotions` refactor and earlier iter-194 IdentityComponent
  template. Consumer sites add explicit `[Typeclass]` binders. Surfaces the
  sorry-chain in the dependency graph and prevents typeclass synthesis from
  silently routing through the unsound carrier.

## Known blockers (do NOT retry)

- **Mathlib b80f227 has no `IsNormalScheme`** — gates Lane RCI helper (d)
  closure. iter-194 mathlib-analogist Route B applies (project-side
  substrate OR Mathlib upstream PR).
- **Mathlib b80f227 has no `GeometricallyIrreducible` on `Proj`** —
  iter-182 + iter-196 scout confirmed. Base-change-of-Proj infrastructure is
  the load-bearing 200-350 LOC gap.
- **Mathlib b80f227 has no `constantSheaf` Full/Faithful on irreducible
  spaces or PUnit** — gates Lane H non-empty closures.
- **Mathlib b80f227 has no `Scheme.Hom.ofFunctionFieldEmbedding`** — gates
  Lane I `degree_positivePart_principal_eq_finrank` body close.
- **`Scheme.Hom.app` rewriting fails by dependent motive** — see Reusable
  proof patterns above for the canonical workaround.

## Reviewer-subagent findings (lean-auditor + 6× lean-vs-blueprint-checker)

### lean-auditor `iter196` (report at `logs/iter-196/lean-auditor-iter196-report.md`)

**Headline**: NO new must-fix items introduced by iter-196 changes. All three
iter-195 must-fix items (WeilDivisor:746 + Thm32:194 + AlbaneseUP:183) are
confirmed RESOLVED by the iter-196 plan-phase refactors (`must-fix-demotions`
+ `carrier-soundness-fgapic`).

**Major findings** (M1-M21 in the report):

- **M1** — FGAPicRepresentability co-dependency chain `HasPicScheme → HasPicSharp`
  (integrated into CRIT-4 above).
- **M2** — Lane E `iotaGm_chart1_appIso_eval` blocks the rigidity chain
  (integrated into CRIT-1 above; the iter-197 prescription closes M2 directly).
- **M3** — WeilDivisor `isRegularInCodimOneProjectiveLineBar` body sorry
  (integrated into MED-1 above; `hy_ne_bot` named residual).
- **M4** — RationalCurveIso helper (a) still sorry (integrated into MED-4).
- **M5** — OCofP `functionField_const_of_complete_curve_of_orderZero`
  (integrated into MED-2).
- **M6** — H1Vanishing 8 declarations all sorry-bodied (integrated into MED-3).
- **M7** — Thm32 `isReduced_of_smooth_over_field` named sorry; the inline-sorry
  must-fix from iter-195 is RESOLVED. Plan agent: this is now a named-Tier-3
  honest typed sorry, deferred to iter-198+ work.
- **M8** — AlbaneseUP `bundle := sorry` is acceptable; 4 derived declarations
  demoted from `instance` to `def`/`theorem` per iter-195 must-fix-demotions
  refactor.
- **M9** — BareScheme `projectiveLineBar_geomIrred` is the 200-350 LOC
  substrate gap (Helper A `Proj 𝒜 ⊗ K ≅ Proj 𝒜 ×_S Spec K` load-bearing).
- **M10-M21** — assorted Tier-3 honest scaffold sorries across `Albanese/`,
  `Picard/`, `RiemannRoch/`, `Cotangent/`, `Genus0BaseObjects/`,
  `Jacobian.lean`, `RigidityKbar.lean`. All documented; none must-fix.

**Minor findings** (m1-m7):

- **m1** — Annotate `instHasPicScheme` with `-- ⚠ co-depends on instHasPicSharp`
  (integrated into CRIT-4 above).
- **m2** — Stale "iter-196 target" comment on `iotaGm_chart1_appIso_eval`; update
  to current blocking status. **Plan agent action**: 1-line comment refresh
  during iter-197 Lane E prover dispatch.
- **m3** — Short docstring on `h0_sub_h1_lineBundleAtClosedPoint_eq_two` should
  be expanded to match `functionField_const_of_complete_curve_of_orderZero`
  standard. Optional iter-197 cleanup.
- **m4** — `bundle` docstring should explicitly note all 4 derived decls are
  `def`/`theorem`. Optional iter-197 cleanup.
- **m5** — H1Vanishing has no iter-196 progress marker. Plan agent: if Lane H
  is dispatched again iter-197+, annotate the in-scope sorries with current
  blocker status.
- **m6** — `degree_positivePart_principal_eq_finrank` excuse comment should
  include iter-196+ concrete engagement plan. Optional iter-197 cleanup.
- **m7** — ChartAlgebra.lean L25 stale historical reference to "iter-145
  `: True := sorry` placeholders"; move to CHANGELOG. Optional cleanup.

### lean-vs-blueprint-checker (6 slugs: `avr`, `barescheme`, `h1v`, `ocofp`, `rci`, `wd`)

- **ocofp** — **complete** (6.3 min). Report at
  `logs/iter-196/lean-vs-blueprint-checker-ocofp-report.md`. 0 must-fix;
  3 major (2 blueprint `\lean{...}` pins to non-existent declarations
  +1 `\leanok`-inside-`\uses` formatting bug). All chapter-side
  housekeeping; integrated into CRIT-3 above.
- **h1v** — **complete** (6.4 min). Report at
  `logs/iter-196/lean-vs-blueprint-checker-h1v-report.md`. **3 must-fix-this-iter**
  findings (all blueprint-side: non-empty branch sketch under-specifies
  Mathlib gap; inner iso sketch missing; stale `\uses` on
  `skyscraperSheaf_isFlasque`); 4 major; 2 minor. Integrated into CRIT-0
  above as a HARD GATE blocker on H1Vanishing.lean iter-197 prover
  re-dispatch.
- **wd** — **complete** (4.1 min). Report at
  `logs/iter-196/lean-vs-blueprint-checker-wd-report.md`. 0 must-fix;
  1 major: `isRegularInCodimOneProjectiveLineBar` (the iter-196
  demotion-target with the new 160-LOC Route 2 body + `hy_ne_bot` named
  residual) has NO `\lean{...}` blueprint pin. Plan agent: when
  dispatching the iter-197 blueprint-writer for OCofP (CRIT-3) or H1V
  (CRIT-0), consider adding a `\lean{AlgebraicGeometry.isRegularInCodimOneProjectiveLineBar}`
  block to `RiemannRoch_WeilDivisor.tex` with a sketch of the Route 2
  PID-transfer recipe and the Stacks 02IZ/005X residual. Not blocking
  iter-197 prover dispatch on WeilDivisor.lean.
- **avr** — **complete** (6.6 min). Report at
  `logs/iter-196/lean-vs-blueprint-checker-avr-report.md`. **1 must-fix-this-iter**
  (`Proj.basicOpenIsoSpec_inv_app_top` block missing) + 4 major
  (Step 1 sketch references non-existent declaration; 2 iter-196 landed
  primitives have no `\lean{...}` block). Integrated into CRIT-0a above
  as a HARD GATE blocker on AbelianVarietyRigidity.lean iter-197 prover
  re-dispatch.
- **rci** — **complete** (5.3 min). Report at
  `logs/iter-196/lean-vs-blueprint-checker-rci-report.md`. 0 must-fix,
  0 major, 3 minor (stale NOTE comment naming the iter-194
  `of_fiberToSpecResidueField` method that was replaced iter-196 with
  `of_finite_preimage_singleton`; +2 unpinned public-helper coverage
  gaps on `Hom.poleDivisor` / `Hom.poleDivisor_degree_eq_finrank`). The
  stale NOTE comment was refreshed by the review agent directly
  (`% NOTE (iter-194 reviewer; refreshed iter-196)` at
  `RiemannRoch_RationalCurveIso.tex` ~L300). Coverage-gap pin additions
  deferred to optional iter-197 blueprint-writer.
- **barescheme** — **complete** (4.5 min). Report at
  `logs/iter-196/lean-vs-blueprint-checker-barescheme-report.md`. **1
  must-fix-this-iter** (`lem:projectiveLineBar_geomIrred` blueprint block
  under-specifies the Lean recipe; needs Helper A `Proj ⊗ K ≅ Proj ×_S
  Spec K` + Helpers B-E) + 2 major (no pins for
  `projectiveLineBar_isProper` or the
  `mvPolynomialFin_isStandardSmoothOfRelativeDimension` 5-declaration
  chain) + 2 minor. Integrated into CRIT-0b above; the gate is the same
  AVR chapter as CRIT-0a, so a single blueprint-writer dispatch covers
  both files.
  Reports will land at
  `logs/iter-196/lean-vs-blueprint-checker-<slug>-report.md`. The
  iter-197 plan agent should read each directly — any
  must-fix-this-iter finding gates the corresponding file from prover
  re-dispatch per the HARD GATE rule.
