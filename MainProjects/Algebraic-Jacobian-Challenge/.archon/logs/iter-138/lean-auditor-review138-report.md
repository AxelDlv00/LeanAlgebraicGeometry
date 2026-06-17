# Lean Audit Report

## Slug
review138

## Iteration
138

## Scope
- files audited: 14
- files skipped (per directive): 0 — all `.lean` files under the project
  root were read in full (excluding `.lake/`, `lake-packages/`, and the
  `.archon/` snapshot/lane subtrees, per directive).

Files (in audit order):

1. `AlgebraicJacobian.lean`
2. `AlgebraicJacobian/AbelJacobi.lean`
3. `AlgebraicJacobian/Differentials.lean`
4. `AlgebraicJacobian/Genus.lean`
5. `AlgebraicJacobian/Jacobian.lean`
6. `AlgebraicJacobian/Rigidity.lean`
7. `AlgebraicJacobian/RigidityKbar.lean`
8. `AlgebraicJacobian/Cotangent/GrpObj.lean` ← **focus area**
9. `AlgebraicJacobian/Cohomology/SheafCompose.lean`
10. `AlgebraicJacobian/Cohomology/StructureSheafAb.lean`
11. `AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean`
12. `AlgebraicJacobian/Cohomology/MayerVietorisCore.lean`
13. `AlgebraicJacobian/Cohomology/MayerVietorisCover.lean`
14. `references/challenge.lean`

## Per-file checklist

### AlgebraicJacobian.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Project root barrel; 12 imports, no declarations. Clean.

### AlgebraicJacobian/AbelJacobi.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - All three protected projections (`ofCurve`, `comp_ofCurve`,
    `exists_unique_ofCurve_comp`) reduce to the witness's `isAlbaneseFor`
    fields via `letI`-injected instances. Bodies are honest one-liners
    modulo instance plumbing; no sorries; status docstring matches code.

### AlgebraicJacobian/Differentials.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - `relativeDifferentialsPresheaf` and `relativeDifferentialsPresheaf_obj_kaehler`:
    clean; `_obj_kaehler` is a `rfl`-level definitional unfold, justified
    because the LHS is literally the construction body.
  - `kaehler_localization_subsingleton` / `kaehler_quotient_localization_iso`:
    honest closures, well-typed proofs.
  - `smooth_locally_free_omega`: the forward Jacobian-criterion statement;
    the docstring **explicitly discloses** that the converse is false
    without H¹-cotangent vanishing, with the counterexample
    `Spec k → Spec k[t]`, `t ↦ 0`. This is responsible disclosure, not
    an excuse-comment — it documents a mathematical scope choice and
    points to `Differentials.tex` for the discussion. No flag.

### AlgebraicJacobian/Genus.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - `genus C := Module.finrank k (Scheme.HModule k (Scheme.toModuleKSheaf C) 1)`
    — one-liner against the iter-009 `HModule` carrier. Matches its
    docstring and the mathematical definition. Clean.

### AlgebraicJacobian/Jacobian.lean
- **outdated comments**: none flagged this iter (carry-over from earlier iters; see notes)
- **suspect definitions**: 2 (load-bearing sorries — see notes)
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none in the modern sense; the status docstrings
  classify the two sorries as Phase-C scaffolding work
- **notes**:
  - L193–197 `genusZeroWitness`: `:= sorry`. Load-bearing — the M2.a
    rigidity-keystone existence claim. Status documented in the
    docstring (iter-127 scaffold, "closure deferred to iter-138+"); the
    "iter-138+" deferral language is reaching past the present iter
    without further progress this iter — minor escalation noted.
  - L219–223 `positiveGenusWitness`: `:= sorry`. M3 territory, "off-
    critical-path". Honest scaffold; status accurately documented.
  - `nonempty_jacobianWitness` (L249–254): now `by_cases h : genus C = 0`
    decomposing into the two scaffolds. The restructure is honest — the
    inline-sorry was lifted into the two arm-witnesses where the
    mathematical content lives.

### AlgebraicJacobian/Rigidity.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - `Scheme.Over.ext_of_eqOnOpen` is fully closed via a 4-step body
    (Mathlib's `ext_of_isDominant_of_isSeparated'` reduction). The
    "Hypothesis history" docstring narrates two earlier iterations'
    refactors; not stale relative to the current Lean (the points it
    discusses are exactly what the signature reflects). Long but
    accurate.

### AlgebraicJacobian/RigidityKbar.lean
- **outdated comments**: none flagged
- **suspect definitions**: 1 (load-bearing sorry — see notes)
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none (status block is descriptive, not excuse-style)
- **notes**:
  - L75–87 `rigidity_over_kbar`: `:= sorry`. Mumford §4 keystone, M2.a.
    Iter-126 scaffold; closure declared "gated on the shared cotangent-
    vanishing Mathlib pile (iter-129+)". Status accurate, but this is
    iter 138 — i.e. the pile has been under construction for 12 iters
    and `rigidity_over_kbar` is the load-bearing consumer that has not
    yet started body work. Not an excuse-comment per se; flagged at
    **major** as a wide-scope deferred load-bearing claim.

### AlgebraicJacobian/Cotangent/GrpObj.lean
- **outdated comments**: 5 (line-anchor drift — directive says
  carry-over, not re-flagged as new; re-summarised in `Major` for
  completeness)
- **suspect definitions**: 3 (`basechange_along_proj_two_inv_derivation`,
  `basechange_along_proj_two_inv`, `relativeDifferentialsPresheaf_basechange_along_proj_two`
  — each is `noncomputable def` whose construction is supported by
  one or more `sorry`-bodied components; see Must-fix block)
- **dead-end proofs**: 0 (each sorry is in a documented partial-construction
  scaffold, not a proof attempt going in a wrong direction)
- **bad practices**: see notes (Route (b)-via-adjunction-transpose
  construction relies on `:= sorry` `letI` for `IsIso`)
- **excuse-comments**: 3 — "Iter-139+ target" at L580, L584, L622-style
  attached to sorries
- **notes**:
  - L161–200 `cotangentSpaceAtIdentity`: fully constructed pure-term
    `noncomputable def`. The `Classical.choose`-chain is acknowledged in
    the docstring; the construction is honest. No sorry.
  - L210–231 `cotangentSpaceAtIdentity_eq_extendScalars`: honest
    structural-shape acceptance theorem. No sorry.
  - L256–294 `cotangentSpaceAtIdentity_finrank_eq`: fully closed rank
    lemma (iter-132). No sorry.
  - L296–325 docstring block (Piece (i.b) header): accurate roadmap;
    references `mulRight_globalises_cotangent`, `relativeDifferentialsPresheaf_basechange_along_proj_two`,
    `relativeDifferentialsPresheaf_restrict_along_identity_section`.
    No stale forward-references in this block.
  - L348–383 `shearMulRight`: structural iso closed by hand. Proof is
    long but readable; uses `MonObj.lift_lift_assoc` /
    `GrpObj.lift_comp_inv_left/right` lemmas. Honest.
  - L385–393 `shearMulRight_hom_fst/snd`: tagged `@[reassoc (attr := simp)]`.
    OK.
  - L423–425 `schemeHomRingCompatibility`: clean noncomputable def of
    the φ' adjunction transpose. Distinguished in the docstring from
    the inline `Scheme.Hom.toRingCatSheafHom` form. OK.
  - L457–462 `private lemma section_snd_eq_identity_struct`: 3-line
    `rw + rfl`. Clean.
  - L464–524 large iter-138 docstring on `_basechange_along_proj_two`:
    long but informative. **Caveat**: the block's accounting "1 hollow
    scaffold sorry → 3 narrowly-scoped concrete sorries (each documented
    + each strictly smaller than the original load-bearing gap)" is
    self-congratulatory. From the auditor's stance, all three sub-
    sorries are still `sorry`. They are smaller in *surface area*, but
    one of them (`d_app`) is the load-bearing well-definedness fact
    *without which the constructed term is not actually a derivation*.
    See Must-fix.
  - L547–585 `basechange_along_proj_two_inv_derivation`: builds a
    `PresheafOfModules.Derivation'` via `Derivation'.mk +
    ModuleCat.Derivation.mk`. The pointwise `d_add` and `d_mul` are
    closed honestly via `RingHom.map_add/mul + ModuleCat.Derivation.d_add/mul`.
    **The `d_app` law (zero on source-ring image) and the `d_map`
    naturality law are `sorry`.** Without those, the constructed term is
    NOT a derivation in the claimed type — the type only typechecks
    because `Derivation'.mk` takes the laws as proof arguments and
    accepts `sorry` there. **Must-fix.**
  - L596–610 `basechange_along_proj_two_inv`: builds the inverse map
    via `DifferentialsConstruction.isUniversal'.desc` applied to the
    above derivation. **Inherits the two sorries above transitively**:
    this `def` is well-typed only because the universal-property `.desc`
    accepts the sorry-supported derivation as input. **Must-fix.**
  - L612–625 `relativeDifferentialsPresheaf_basechange_along_proj_two`:
    `letI : IsIso (basechange_along_proj_two_inv G) := sorry` followed
    by `(asIso (basechange_along_proj_two_inv G)).symm`. The whole iso
    is therefore sorry-supported. **Must-fix.**
  - L645–688 `relativeDifferentialsPresheaf_restrict_along_identity_section`:
    fully closed iter-136 work (no sorry). The `pullbackComp` + `eqToIso`
    chase + `change` + `rw [section_snd_eq_identity_struct]` reads
    cleanly. OK.
  - L690–752 docstring on `mulRight_globalises_cotangent`: accurate
    multi-step outline.
  - L741–752 `mulRight_globalises_cotangent`: body is `:= sorry`. Main
    lemma of Piece (i.b). **Must-fix.**

### AlgebraicJacobian/Cohomology/SheafCompose.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Single instance, honestly closed by `Limits.comp_preservesLimits +
    hasSheafCompose_of_preservesLimitsOfSize`. Status docstring matches.

### AlgebraicJacobian/Cohomology/StructureSheafAb.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Three declarations, all honest closures (`inferInstance`,
    `HasExt.standard _`, and a one-line `sheafCompose.obj` construction).

### AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean
- **outdated comments**: 1 (see notes; "iter-046+" / "queued iter-XYZ+"
  language in older docstrings is not actively misleading)
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - 877-line file; most declarations are gap-fill instances or
    transport lemmas, all closed honestly with cited lemmas.
  - Long docstrings on `module_finite_globalSections_of_isProper` (L548–584)
    and the iter-046 chain (L656–720) are detailed but accurate to the
    code.
  - L48: history note correctly explains that the per-affine-open variant
    `IsAffineHModuleHomFinite` was a dead-end (Γ(U, O_C) not finite over
    k on a proper affine open) and has been removed. Honest historical
    disclosure, not a flag.
  - Many "iter-N+ queued" forward references (L26, L92, L171, L302, L329,
    L389, L412, L431, L460, L494, etc.) — by directive these are
    carry-over noise. Not re-flagged.

### AlgebraicJacobian/Cohomology/MayerVietorisCore.lean
- **outdated comments**: none flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 1 minor (private namespace usage — see notes)
- **excuse-comments**: none
- **notes**:
  - `Abelian.Ext.chgUniv_add/_smul` are declared `private lemma` in the
    `Abelian.Ext` namespace. This is fine project-locally but the
    `private` modifier is the only thing preventing namespace collision
    with future Mathlib. **Minor**.
  - `HModule'_*` chain (L114–625): all closed (no sorries). Iter-016 → iter-026
    abstract MV LES construction; each step has a precise docstring
    naming the Mathlib mirror lemma and line. Auditor-friendly.
  - L354 `set_option backward.isDefEq.respectTransparency false in`
    appears on `HModule'_shortComplex_f_mono`, L523 on
    `HModule'_biprodAddEquiv_symm_biprodIsoProd_hom_toBiprod_apply`,
    L539 on `HModule'_mk₀_f_comp_biprodAddEquiv_symm_biprodIsoProd_hom`,
    L565 on `HModule'_sequenceIso`. Justified in the comments (Mathlib's
    backward-isDefEq fragility on biprod projections). Not flagged.

### AlgebraicJacobian/Cohomology/MayerVietorisCover.lean
- **outdated comments**: 1 (forward-reference at L676 says "iter-054+
  work" — iter is now 138 and the producer has not landed; see notes)
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - The `HasAffineCechAcyclicCover` class (L675–682) bundles the
    existence claim for the Čech-acyclic basic-open cover input. The
    docstring at L656–673 says "iter-054+ work" will instantiate this
    for `Scheme.toModuleKSheaf C`; current iter is 138, so this forward
    reference has been wrong for ~84 iters. Not a Lean-content defect
    (the class is correctly stated), but the forward-reference is stale.
    **Minor** (carry-over per directive, not re-flagged at major).
  - All other declarations in this cohort are clean — corner-bridge
    specialisations + finrank transports + Module.Finite transports +
    `IsCechAcyclicCover` / `HasCechToHModuleIso` consumers, each backed
    by an explicit Mathlib mirror.
  - L504–505 docstring fragment names `[propext, Classical.choice,
    Quot.sound]` as the project's accepted axiom basis; honest disclosure.

### references/challenge.lean
- **outdated comments**: none
- **suspect definitions**: none flagged in this file directly — this is
  the challenge.lean reference (kept as the upstream challenge
  statement; bodies are all `sorry`-bodied stub signatures, by design,
  as it is the *target* file, not project Lean content)
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - This file contains the upstream sorry-bodied challenge statements
    (`genus`, `Jacobian`, group-scheme structure, smoothness witness,
    properness, geometric irreducibility, `ofCurve`, `comp_ofCurve`,
    `exists_unique_ofCurve_comp`). It is the *spec*, not project work;
    all sorries here are expected and not flagged.
  - **Minor**: the `genus` and `Jacobian` declarations in this file
    omit `noncomputable`, which would fail to compile if they were
    actual project source (the bodies are `sorry`, but the intended
    real bodies are noncomputable). Since this is an external spec
    file (it imports `Mathlib`, lives under `references/`), the
    discrepancy is benign — but a reader cross-checking against the
    project's `Genus.lean` / `Jacobian.lean` should be aware that the
    project versions use `noncomputable def` where this file uses
    bare `def`.

---

## Must-fix-this-iter

Per the auditor's directive these are non-negotiable. The four sorries
introduced or persisting in `AlgebraicJacobian/Cotangent/GrpObj.lean`
this iter all qualify as "Suspect bodies on substantive claims" because
they are `:= sorry` (directly or via a `letI := sorry`) on load-bearing
algebraic-geometry constructions.

- `AlgebraicJacobian/Cotangent/GrpObj.lean:581` — `sorry` for the `d_app`
  (vanishing-on-source-ring-image) law inside the
  `basechange_along_proj_two_inv_derivation` `noncomputable def`. **Why
  must-fix:** this is the well-definedness law that makes the constructed
  term actually a derivation into the *relative* differentials presheaf;
  without it, the `def` typechecks only because `Derivation'.mk` takes
  this law as a proof argument. The downstream `basechange_along_proj_two_inv`
  and `relativeDifferentialsPresheaf_basechange_along_proj_two` are
  meaningful *only if this fact is true*. Excuse-comment ("Iter-139+
  target") attached.
- `AlgebraicJacobian/Cotangent/GrpObj.lean:585` — `sorry` for the
  `d_map` (cross-open naturality) law inside the same derivation. **Why
  must-fix:** same reason — required for the constructed term to be a
  morphism in the category of derivations. Excuse-comment ("Iter-139+
  target") attached.
- `AlgebraicJacobian/Cotangent/GrpObj.lean:624` — `letI : IsIso
  (basechange_along_proj_two_inv G) := sorry` inside the body of
  `relativeDifferentialsPresheaf_basechange_along_proj_two`. **Why
  must-fix:** the resulting `≅` is `(asIso _).symm`, so the `IsIso`
  sorry is *the* content of the iso. The declaration claims a structural
  isomorphism `Ω_{(G⊗G)/G} ≅ pr_2^* Ω_{G/k}` but supplies no proof.
- `AlgebraicJacobian/Cotangent/GrpObj.lean:752` —
  `mulRight_globalises_cotangent := sorry`. **Why must-fix:** main lemma
  of Piece (i.b); declared at the sheaf-level RHS shape, body is a
  single `sorry`. Has been a `sorry` since iter-135 (carry-over) and
  this iter's work is on the prerequisite Step 2, not the main lemma.

(Carry-over sorries in `Jacobian.lean` (L197 `genusZeroWitness`, L223
`positiveGenusWitness`) and `RigidityKbar.lean` (L87 `rigidity_over_kbar`)
are NOT classified as must-fix-this-iter because the directive's prior-
iter audits have classified them as scoped Phase-C / Phase M2.a
scaffolding sorries, and this iter's prover lane was not directed at
them. They remain visible as **Major** below.)

## Major

- `AlgebraicJacobian/Cotangent/GrpObj.lean:61` (carry-over) — docstring
  says `cotangentSpaceAtIdentity_finrank_eq` is at "line 244 below";
  actual location is line 256. Per directive, do-not-re-report; logged
  here for traceability.
- `AlgebraicJacobian/Cotangent/GrpObj.lean:107` (carry-over) — same line-
  anchor drift; "line 244" → actual 256.
- `AlgebraicJacobian/Cotangent/GrpObj.lean:146` (carry-over) — same.
- `AlgebraicJacobian/Cotangent/GrpObj.lean:155` (carry-over) — same.
- `AlgebraicJacobian/Cotangent/GrpObj.lean:160` (carry-over) —
  `cotangentSpaceAtIdentity_eq_extendScalars` is at "line 198 below";
  actual location is line 210. Per directive, do-not-re-report.
- `AlgebraicJacobian/Cotangent/GrpObj.lean:483–487` — the iter-138
  status block in the docstring of
  `relativeDifferentialsPresheaf_basechange_along_proj_two` frames the
  iter as "1 hollow scaffold sorry → 3 narrowly-scoped concrete sorries
  (each documented + each strictly smaller than the original load-bearing
  gap)." This is **net-progress framing that overstates the change**.
  The previous iter had 1 sorry on the iso body; this iter has 3 sorries
  supporting the iso construction *plus* the original iso body is now
  `(asIso _).symm` with an `:= sorry` `IsIso` — so the iso is *still*
  fully sorry-supported. The reader is told "narrowly-scoped" but the
  `d_app` sub-sorry is the substantive well-definedness check, not a
  formality. Recommend rewriting the status to acknowledge that no
  *mathematical* content has been verified, only that the construction
  *shape* has been laid out.
- `AlgebraicJacobian/RigidityKbar.lean:87` — `rigidity_over_kbar :=
  sorry`, declared "gated on iter-129+ pile" in a docstring dated to
  iter-126. Iter is now 138. The load-bearing classical input (Mumford
  Ch. II §4) has not started body work after 12 iters of pile
  preparation. **Not** classified as must-fix because the directive's
  carry-over policy applies, but the deferral chain is now long enough
  that a status refresh would be worthwhile.
- `AlgebraicJacobian/Jacobian.lean:186` — `genusZeroWitness` body
  closure "deferred to iter-138+" in iter-127 docstring; iter is now
  138, no closure delivered. Update or re-deadline.
- `AlgebraicJacobian/Jacobian.lean:210` — `positiveGenusWitness`
  docstring says "iter-134 scaffold"; iter is now 138, still
  `:= sorry`. Status accurate ("off-critical-path"), not flagged
  must-fix.
- `AlgebraicJacobian/Cohomology/MayerVietorisCover.lean:667–668` —
  docstring on `HasAffineCechAcyclicCover` says "substantive iter-054+
  work will instantiate ... via Koszul + Čech-derived comparison"; iter
  is now 138 and the producer instance has not landed. Forward-reference
  is ~84 iters old.

## Minor

- `AlgebraicJacobian/Cohomology/MayerVietorisCore.lean:60, 79` —
  `Abelian.Ext.chgUniv_add` and `_smul` are declared `private` inside
  the `Abelian.Ext` namespace. Project-locally fine; flag only because
  this is the kind of declaration that should ideally be upstreamed to
  Mathlib (the comments at L93 say so explicitly: "iter-034 Mathlib gap-
  fill"), so the `private` modifier is a soft-blocker for that path.
- `AlgebraicJacobian/Cotangent/GrpObj.lean:177–180` — the
  `Classical.choose`-chain `let h₁ := h.choose_spec ; let V := h₁.choose
  ; let h₂ := h₁.choose_spec ; let e := h₂.choose ; let hxV := h₂.choose_spec.1`
  is repeated verbatim in the rank lemma at L263–273 (and a third copy
  is implicit in `cotangentSpaceAtIdentity_eq_extendScalars` at L223–226).
  Three near-identical extractions live in this file. A `noncomputable
  abbrev` packaging the four extracted witnesses (`U, V, e, hxV`) into
  a single struct would let all three consumers share one extraction
  point and reduce drift risk if `smooth_locally_free_omega`'s shape
  ever changes. Refactor candidate, not a defect.
- `references/challenge.lean:52, 58` — `genus` and `Jacobian` lack the
  `noncomputable` modifier the project's own `Genus.lean` and
  `Jacobian.lean` carry. Benign in an external spec file but worth
  noting for any reader cross-checking.

## Excuse-comments (always called out separately)

Three excuse-comments were flagged this iter, all attached to the
iter-138 partial Route (b) construction in
`AlgebraicJacobian/Cotangent/GrpObj.lean`. Each is verbatim per the
rule.

- `AlgebraicJacobian/Cotangent/GrpObj.lean:577–581`:
  `-- d_app: KaehlerDifferential.D of (ψ.app X) ∘ (φ_G.app X) vanishes.`
  `-- This follows from (fst G G).left ≫ G.hom = (snd G G).left ≫ G.hom in Over (Spec k),`
  `-- which makes (ψ.app X) ∘ (φ_G.app X) factor through the source presheaf of LHS.`
  `-- Iter-139+ target.`
  `sorry`
  Severity: **critical**. Attached to the well-definedness law of
  `basechange_along_proj_two_inv_derivation`, which the constructed
  derivation depends on for its very type to be honest.
- `AlgebraicJacobian/Cotangent/GrpObj.lean:583–585`:
  `-- d_map naturality: chase of (snd G G).left.c.naturality + KaehlerDifferential.map_d.`
  `-- Iter-139+ target.`
  `sorry`
  Severity: **critical**. Same situation: naturality across opens is
  required by the derivation's type.
- `AlgebraicJacobian/Cotangent/GrpObj.lean:620–624`:
  `-- Iter-138 partial closure: build the iso via the inverse map +`
  `-- IsIso-of-inverse + asIso ... |>.symm. The IsIso fact is the`
  `-- third concrete sub-piece; see this declaration's docstring for the`
  `-- closure paths (Route (a) chart-unfolding-helper or local-iso check).`
  `letI : IsIso (basechange_along_proj_two_inv G) := sorry`
  Severity: **critical**. The `:= sorry` carries the entire iso claim
  of `relativeDifferentialsPresheaf_basechange_along_proj_two`.

All three are framed as "iter-139+ target" / "third concrete sub-piece"
— deferred-work framing. The directive specifically asks for extra
attention to these patterns. The deferral is honest (the docstring
discloses the gaps) but the *outcome* is the same as any other sorry:
the constructed value is currently unsupported, and downstream consumers
that import `relativeDifferentialsPresheaf_basechange_along_proj_two`
or `mulRight_globalises_cotangent` will be silently sitting on these
sorries.

## Severity summary

- **must-fix-this-iter**: 4 — the four iter-138 sorries inside the
  Route (b) construction chain in `Cotangent/GrpObj.lean` (the two
  derivation laws, the `IsIso letI`, and the main-lemma body of
  `mulRight_globalises_cotangent` which has been `sorry` since iter-135
  but is the consumer of the present iter's work).
- **major**: 9 — 5 carry-over line-anchor stalenesses (per directive,
  not new), 1 docstring framing overstatement, and 3 long-deferred load-
  bearing sorries with status text that has outlived its iter window.
- **minor**: 3 — `private`-namespaced Mathlib gap-fills, repeated
  `Classical.choose`-chains in `Cotangent/GrpObj.lean`, missing
  `noncomputable` in the external `references/challenge.lean` spec.
- **excuse-comments**: 3 (also counted under must-fix-this-iter above;
  called out separately because they document the project lying to
  itself — "Iter-139+ target" reframes "this is sorry" as "this is
  schedule").

Overall verdict: iter-138 landed a substantive structural skeleton for
Route (b) of Piece (i.b), but the iso `relativeDifferentialsPresheaf_basechange_along_proj_two`
and the main lemma `mulRight_globalises_cotangent` remain fully sorry-
supported; the docstring framing slightly overstates progress and
several long-standing forward-references have outlived their declared
iter windows.
