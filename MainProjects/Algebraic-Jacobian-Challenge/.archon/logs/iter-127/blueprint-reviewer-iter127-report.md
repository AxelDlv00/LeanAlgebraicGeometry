# Blueprint Review Report

## Slug
iter127

## Iteration
127

## Top-level summaries

### Incomplete parts

- `RigidityKbar.tex` § "The shared cotangent-vanishing Mathlib pile" piece (i) (L63–64): the decomposition is named at high level (Lie-algebra-of-`GrpObj` + mulRight-globalisation + relative-cotangent-presheaf trivialisation) and the target names `omega_free` / `omega_rank_eq_dim` are nominated, but **no sub-lemma chain is written out**. Piece (i) is the dominant 800–1500 LOC cost and the iter-128 META-PATTERN TRIPWIRE explicitly requires a concrete prover-ready piece-(i) sub-lemma staged in iter-127. The chapter currently scopes the build but is not prover-ready for piece (i): the first sub-target (presumably the Lie algebra of a `GrpObj` over a field, or the globalisation lemma for mulRight) is neither stated as a `\begin{lemma}` nor `\lean{...}`-tagged.
- `Jacobian.tex` § C.2 / § C.3 ("trivial witness"): the **`genusZeroWitness` builder shape** that iter-127 will scaffold is not separately stated. The chapter describes the genus-0 case via paragraphs (0)+(C.1)–(C.3) inside the `nonempty_jacobianWitness` proof body, but does NOT carve out a named genus-stratified witness builder with the `C(k) = ∅` vacuity vs `C(k) ≠ ∅` rigidity-application dichotomy explicitly captured. The dichotomy IS mentioned in `RigidityKbar.tex` § "Use in the project" (L88), but the *consumer* chapter for the new declaration (Jacobian.tex) does not state the new Lean target's signature/shape.
- Multi-route gap: the STRATEGY.md "Alternative: direct over-k rigidity" (L505–519), which drops M2.c entirely under C(k) ≠ ∅ via the over-k Brauer–Severi route + over-k cotangent triviality, has **zero blueprint coverage**. Neither `RigidityKbar.tex` (over-`k̄` only) nor `Jacobian.tex` § C.2 (genus-0 via base-change-and-descent) mentions the over-k alternative path. STRATEGY.md notes the iter-127 `mathlib-analogist-cotangent-vanishing-pile-over-k-iter127` consult is scoping it; that is research, not blueprint coverage.

### Proofs lacking detail

- `RigidityKbar.tex` § C.2.e (L55): "Standard reduced-source / separated-target argument, integrated into the application of \cref{thm:GrpObj_eq_of_eqOnOpen} in C.2.b." — collapses a non-trivial step (set-level → scheme-level promotion) into one sentence pointing at C.2.b. For an iter-129+ prover lane this is acceptable because `Scheme.Over.ext_of_eqOnOpen` (which absorbs C.2.e) is already formalised; but the chapter does not say so explicitly. Suggested fix: one sentence clarifying that C.2.e is *absorbed* by C.2.b's call to `ext_of_eqOnOpen` because that lemma takes set-level/restriction-level agreement and returns scheme-morphism equality.
- `RigidityKbar.tex` piece (iii) "characteristic-$p$ handling" (L68–74): commits to Option A (Frobenius iteration) but the sketch does not explain how Frobenius iteration descent works for the C.2.d application (i.e. how iterating `f ∘ F^n` and using smoothness of A descends the conclusion back to f). Adequate for scoping; thin for the iter-129+ prover lane.
- `RigidityKbar.tex` does not state whether **`[IsAlgClosed kbar]`** will need to be added when piece (iii) (or any other piece) lands. The current scaffold uses `{kbar : Type u} [Field kbar]` with no algebraic-closure hypothesis (RigidityKbar.lean:56) — the body closure may require strengthening this when piece (iii) lands; the chapter is silent on this.
- `Jacobian.tex` § C.2.d (L332–348): the two-route sketch (dual abelian variety + cotangent bundle) cites Hartshorne and Mumford for inputs but does not explicitly say "the Lean formalisation route is the cotangent-bundle route, piece (iii) Frobenius-iteration committed". Cross-chapter consistency: `RigidityKbar.tex` commits to the cotangent route + Option A, but `Jacobian.tex` still presents both routes as options. This is an informational drift; should be reconciled when M2.a body closure is scheduled.

### Lean difficulty quality

- `Differentials.tex` Step 4.5 (L88–89) cites `\texttt{AlgebraicGeometry.Scheme.component\_nontrivial}` as the lemma supplying `Nontrivial B`. The actual Lean code (`Differentials.lean:139`) does **not** call `component_nontrivial`; it constructs `Nonempty V := ⟨⟨x, hxV⟩⟩` inline and lets `Nontrivial` typeclass synthesis fire. Either the chapter's named lemma exists in Mathlib (in which case the Lean code can be slightly simplified to use it) or it does not (in which case the chapter prose is hallucinated). The iter-126 lean-vs-blueprint checker flagged this as a minor; it survives.
- `RigidityKbar.tex` § "shared pile" piece (i) (L63–64): `\lean{}`-tags `omega_free` and `omega_rank_eq_dim` (as `AlgebraicGeometry.GrpObj.omega_free` and `AlgebraicGeometry.GrpObj.omega_rank_eq_dim`) in prose but **does not declare them as `\begin{lemma}` blocks**. They are PHANTOM targets per the directive's spot-check. A prover dispatched on piece (i) would have no `\lean{...}`-tagged statement block to formalise against — only prose. Severity: poor formulation for prover dispatch.

### Multi-route coverage

- Route "via over-`k̄` rigidity (M2.a + M2.c Galois descent + shared cotangent pile)": **PASS** — covered by `RigidityKbar.tex` (the rigidity-over-`k̄` named declaration + proof decomposition + shared pile inventory) and `Jacobian.tex` § C.2 (the proof-body integration with Galois descent at C.2.f).
- Route "direct over-k rigidity (drops M2.c)": **MISSING** — STRATEGY.md § "Alternative" describes this route (Ω_{A/k} trivial via left-invariant forms over any base field; runs verbatim over k when C(k) ≠ ∅; C(k) = ∅ branch handled by vacuity). No blueprint chapter covers it. The iter-127 `mathlib-analogist-cotangent-vanishing-pile-over-k-iter127` consult will scope the math, but no chapter exists to host the result.
- Route "Route A (Picard scheme via FGA representability)": **PASS** as the Mathlib-gap analysis route (the chapter explicitly catalogues the gap rather than building toward it). Covered in `Jacobian.tex` § "Route A".
- Route "Route B (symmetric powers + Stein factorisation)": **PASS** as gap-analysis. Covered in `Jacobian.tex` § "Route B".

## Per-chapter

### blueprint/src/chapters/Cohomology_SheafCompose.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Auxiliary chapter; one declaration `instHasSheafCompose_forget_CommRing_AddCommGrp` with proof-by-composition prose. Stable and prover-ready.

### blueprint/src/chapters/Cohomology_StructureSheafAb.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Auxiliary chapter; three declarations (`HasSheafify_Opens_AddCommGrp`, `HasExt_Sheaf_Opens_AddCommGrp`, `toAbSheaf`). All `\lean{...}`-tagged and have proofs at the typeclass-plumbing-plus-prose level appropriate for the content.

### blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Extensive chapter covering Phase A step 5 + § cech / `IsAffineHModuleVanishing` / `IsHModuleHomFinite` carriers + Stein producer. All declarations `\lean{...}`-tagged. The carrier classes are correctly documented as "currently unproduced" parallels to `nonempty_jacobianWitness`.

### blueprint/src/chapters/Cohomology_MayerVietoris.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Large chapter with full Mayer–Vietoris infrastructure + 2-affine cover + Čech-acyclic carrier. All `\lean{...}` hints align with `AlgebraicGeometry.Scheme.HModule'_*` declarations. No new findings this iter; matches iter-126 last clean state.

### blueprint/src/chapters/Differentials.tex
- **complete**: true
- **correct**: partial
- **notes**:
  - Post-iter-126-excise state is clean: 5 retained declarations (`relativeDifferentialsPresheaf`, `relativeDifferentialsPresheaf_obj_kaehler`, `smooth_locally_free_omega`, `kaehler_localization_subsingleton`, `kaehler_quotient_localization_iso`), all `\lean{...}`-tagged, all present in `Differentials.lean`.
  - **Naming drift (minor)**: Step 4.5 of Thm `smooth_locally_free_omega` claims to use `AlgebraicGeometry.Scheme.component_nontrivial`, but the actual Lean proof uses `Nonempty V := ⟨⟨x, hxV⟩⟩` + `algebraize`. Chapter prose is slightly out-of-sync with the actual proof body; not prover-blocking since `Differentials.lean` is closed.
  - Cross-ref consistency post-excise: the chapter's prose no longer claims any "bridge" declaration in-tree (correct, since iter-126 excised it). The standalone K\"ahler-localisation utilities (M1.d Mathlib-PR candidate) are preserved with correct attribution. § "Sheaf condition for $\Omega_{X/S}$ (M5)" et al. are correctly framed as deferred milestones.

### blueprint/src/chapters/Genus.tex
- **complete**: true
- **correct**: true
- **notes**:
  - `\lean{AlgebraicGeometry.genus}` definition correctly framed as `Module.finrank k (Scheme.HModule k (Scheme.toModuleKSheaf C) 1)`. Equivalent Serre-duality / Riemann–Roch reformulations are correctly framed as deferred. Stable.

### blueprint/src/chapters/Jacobian.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - Existing content for `IsAlbanese`, `IsAlbanese.ofCurve`, `IsAlbanese.unique`, `Jacobian`, four protected projections, and `nonempty_jacobianWitness` is **stable** and all `\lean{...}`-tagged correctly. The four routes for `nonempty_jacobianWitness` (A Picard / B symmetric powers / C.1–C.3 genus-0 / C.2.f Galois descent) are all documented as gap-analyses.
  - **Iter-127 staging gap**: the planned `genusZeroWitness` builder (a `JacobianWitness C` constructor for the genus-0 case, branching on C(k) = ∅ vacuity vs `rigidity_over_kbar` application) is **not separately captured**. The C.3 "trivial witness" paragraph (L361) describes the underlying-scheme `J := Spec k` choice, but does not state the *separate Lean target's signature* that iter-127's refactor will introduce. The C(k) = ∅ vs C(k) ≠ ∅ dichotomy IS discussed in `RigidityKbar.tex` § "Use in the project" L88 — but as the consumer description, not the new declaration's blueprint shape.
  - **Cross-route silence**: STRATEGY.md § "Alternative: direct over-k rigidity" would, if adopted, eliminate Sub-step C.2.f (Galois descent). Jacobian.tex does not mention this alternative path at all; the M2.c Galois descent step is presented as the only route.
  - Cross-ref to RigidityKbar.tex: Jacobian.tex L358 references `\cref{chap:RigidityKbar}` and `\cref{sec:RigidityKbar_shared_pile}` in prose. There is **no formal `\uses{thm:rigidity_over_kbar}` directive** anywhere in the chapter (the dependency-graph generator may not register the cross-chapter dependency on the new theorem). The directive's spot-check claim of `\uses{thm:rigidity_over_kbar}` does not match what I see in the file; this is a soon flag.

### blueprint/src/chapters/Rigidity.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Post-iter-125 refactor state is clean. Single declaration `thm:GrpObj_eq_of_eqOnOpen` (label retained for historical reasons) named `AlgebraicGeometry.Scheme.Over.ext_of_eqOnOpen`. The proof sketch correctly cites all 4 Mathlib ingredients used by `Rigidity.lean:91+`.
  - "Use in the project" L52–58 correctly cross-refs M2.a and `chap:RigidityKbar` / `thm:rigidity_over_kbar`.

### blueprint/src/chapters/RigidityKbar.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - Statement of `thm:rigidity_over_kbar` is precise, correctly `\lean{AlgebraicGeometry.rigidity_over_kbar}`-tagged, and matches `RigidityKbar.lean:75` (encoding note L29 documents the Option-B choice). `\leanok` is present (will be deterministically managed by `sync_leanok` since body is `sorry`).
  - Proof decomposition C.2.b → C.2.c → C.2.d → C.2.e is present with cross-refs to `thm:GrpObj_eq_of_eqOnOpen` and to `sec:RigidityKbar_shared_pile`. Adequate for iter-126's scaffold and for the iter-129+ body closure plan.
  - **Piece (i) sub-lemma decomposition is HIGH-LEVEL ONLY**. L63–64 names `omega_free` and `omega_rank_eq_dim` as PHANTOM upstream targets and mentions the three-stage decomposition (Lie-algebra-of-GrpObj + mulRight-globalisation + relative-cotangent-presheaf trivialisation), but does not introduce sub-lemmas with `\begin{lemma}` blocks or `\lean{...}` tags for any of these intermediate stages. Iter-128's META-PATTERN TRIPWIRE (per progress-critic-iter126) requires a concrete prover-ready piece-(i) sub-target staged this iter. This blueprint state is **inadequate for iter-128's piece-(i) prover dispatch**: the prover would have no `\lean{...}`-tagged statement to formalise against.
  - C.2.e (L55) waves at "integrated into C.2.b" — minor; could be made explicit that `Scheme.Over.ext_of_eqOnOpen` consumes set-level/restriction-level agreement on a non-empty open and returns scheme-morphism equality, so C.2.e is absorbed.
  - The chapter does **not** discuss whether `[IsAlgClosed kbar]` needs to be added when piece (iii) (Frobenius iteration) lands. The current Lean scaffold has only `[Field kbar]` (RigidityKbar.lean:56); piece (iii) is over a perfect/algebraically-closed base in the classical statement. Soft soon flag for the future body-closure iter.
  - Underscored hypothesis names `_hgenus` (L80) and `_hf` (L85) in the Lean scaffold are documented in the chapter at L29 implicitly (via "Encoding note iter-126"); will be de-underscored when the body lands. Not a blueprint-side issue; chapter-prose is consistent.

### blueprint/src/chapters/AbelJacobi.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Three declarations (`ofCurve`, `comp_ofCurve`, `exists_unique_ofCurve_comp`), all `\lean{...}`-tagged. Each proof reduces to a single Albanese-witness field projection. Cross-ref to `chap:Jacobian` is consistent with Jacobian.tex's existence theorem.

### blueprint/src/chapters/Modules_Monoidal.tex
- **complete**: true (within its own scope)
- **correct**: true (within its own scope)
- **notes**:
  - **ORPHAN**: NOT in `content.tex`. Documents the Picard-scheme route that the project no longer pursues (Phase B/C). Carries `\lean{...}` hints for declarations that may or may not exist; the chapter is out of the iter-126 strategy's scope per STRATEGY.md M2's "no Pic-scheme route" decision.
  - Cleanup candidate — flagged iter-124 / iter-125 / iter-126 reviewers. Recommend a blueprint-writer dispatch this iter to either re-include them in content.tex (if the Picard route is being re-examined) or delete them. Default: delete.

### blueprint/src/chapters/Picard_LineBundle.tex
- **complete**: true (within its own scope)
- **correct**: true (within its own scope)
- **notes**:
  - **ORPHAN** (same status as Modules_Monoidal.tex). Cross-refs to `chap:Modules_Monoidal` (also orphan); self-consistent. Deletion candidate.

### blueprint/src/chapters/Picard_Functor.tex
- **complete**: true (within its own scope)
- **correct**: true (within its own scope)
- **notes**:
  - **ORPHAN**. Cross-refs to `chap:Picard_LineBundle` (orphan). Deletion candidate.

### blueprint/src/chapters/Picard_FunctorAb.tex
- **complete**: true (within its own scope)
- **correct**: true (within its own scope)
- **notes**:
  - **ORPHAN**. Cross-refs to `chap:Picard_Functor` (orphan). Deletion candidate.

## Cross-chapter notes

- `RigidityKbar.tex` § "Use in the project" L88 describes the **`isAlbaneseFor` field's branching**: "When $C(k) \neq \emptyset$, \cref{thm:rigidity_over_kbar} is invoked […]; when $C(k) = \emptyset$, the field is vacuously true (no marked points exist)." This is the M2.b genus-0-witness consumer-side description. **`Jacobian.tex`** does not echo this branching in its own chapter; the C(k) = ∅ vacuity case is essentially absent from Jacobian.tex (whose C.2.f assumes C(k) ≠ ∅ for the marked-point fixture). Symmetrising the two chapters — having Jacobian.tex's `nonempty_jacobianWitness` proof body explicitly carve out the `if C(k) = ∅` vacuity sub-case — would close the iter-127 staging gap.
- `Jacobian.tex` L320–367 (C.2.a–C.2.g) and `RigidityKbar.tex` § "Proof decomposition" (L43–56) use the **same sub-step labels** (C.2.b, C.2.c, C.2.d, C.2.e) for the same content, which is helpful. Iter-126 cross-chapter labelling is consistent. One asymmetry: Jacobian.tex § C.2.d (L332–348) presents BOTH proof routes (dual abelian variety + cotangent bundle); RigidityKbar.tex § "shared pile" commits to the cotangent route + Option A only. When the body closure plan is finalised, the two chapters should agree on the route in prose.
- `Differentials.tex` Step 4.5 `component_nontrivial` (L88) vs `Differentials.lean:139` `Nonempty V`: prose-vs-code naming drift, minor.
- `Jacobian.tex` L358 mentions `\cref{chap:RigidityKbar}` + `\cref{sec:RigidityKbar_shared_pile}` only in prose, **not as a `\uses{thm:rigidity_over_kbar}` directive**. The dependency-graph generator may miss the Jacobian → RigidityKbar dependency. The directive's spot-check claim of `\uses{thm:rigidity_over_kbar}` in Jacobian.tex does not appear in the source. Soon flag — should be added before the iter-128 prover lane runs on RigidityKbar piece (i).

## Strategy-modifying findings (if any)

None this iter. The "direct over-k rigidity" alternative is a strategic alternative under active consult (iter-127 mathlib-analogist dispatch), not a strategy-modifying finding. The plan agent's iter-127 ordering already accounts for it.

## Severity summary

- **must-fix-this-iter**:
  - **`RigidityKbar.tex` piece (i) lacks prover-ready sub-lemma decomposition**. The iter-126 progress-critic META-PATTERN TRIPWIRE for iter-128 requires that iter-127 STAGE a concrete prover-ready piece-(i) sub-lemma. Currently `RigidityKbar.tex` L63–64 only names the top-level targets `omega_free` / `omega_rank_eq_dim` as PHANTOM and gives a three-stage decomposition in prose; no `\begin{lemma}` / `\lean{...}` blocks exist for the intermediate stages (Lie algebra of `GrpObj`, mulRight-globalisation, relative-cotangent-presheaf trivialisation). A blueprint-writer dispatch this iter is required to introduce at least the FIRST prover-ready sub-lemma (most likely: the Lie-algebra-of-`GrpObj` over a field, or the mulRight-globalisation of a left-invariant differential form). Without this dispatch, the iter-128 piece-(i) prover lane will have no `\lean{...}`-tagged target and must be deferred to iter-129+ per the HARD GATE rule.
  - **`Jacobian.tex` does not separately describe the iter-127 `genusZeroWitness` builder shape**. The dichotomy (C(k) = ∅ vacuity vs `rigidity_over_kbar` application for C(k) ≠ ∅) lives in `RigidityKbar.tex` § "Use in the project" L88 but not in the chapter where the new declaration will land. Per the HARD GATE rule, if iter-127's `refactor-m2b-scaffold-iter127` introduces a NEW Lean declaration `genusZeroWitness`, the corresponding blueprint chapter (Jacobian.tex) must `complete: true` cover that declaration before a prover dispatches on its body. **Note**: iter-127 dispatches a *refactor-agent* on `genusZeroWitness`, not a prover; the refactor agent's deliverable is the scaffold + `sorry` body. Whether the HARD GATE applies depends on whether refactor-agents are subject to the same blueprint-completeness gate as provers. Conservative interpretation: dispatch a blueprint-writer this iter to add a `\begin{definition}` / `\lean{...}` block for `genusZeroWitness` to `Jacobian.tex` § C.3 before the refactor agent runs.
  - **Multi-route coverage MISSING — "direct over-k rigidity"**. STRATEGY.md L505–519 mentions this alternative as potentially eliminating M2.c (4–8 iter saving). No blueprint chapter covers it. Per the rule "Routes the strategy mentions but the blueprint does not cover are red flags", this requires a blueprint-writer dispatch. **However**: the iter-127 mathlib-analogist consult is scoping the over-k variant right now; the writer can be deferred to iter-128 once the consult returns with the math content. Conditional must-fix: if the consult endorses the over-k path, dispatch a writer iter-128 (NOT this iter — the math content isn't determined yet). If the consult rejects the over-k path, no chapter is needed and the strategy table is updated. So the actual action this iter is: **wait for the analogist consult; do not dispatch a writer on over-k coverage yet**. Demote to soon-with-trigger.

- **soon**:
  - `Jacobian.tex` does not formalise its cross-chapter dependency on `thm:rigidity_over_kbar` via `\uses{...}` (only via `\cref{...}` in prose). Add a `\uses{thm:rigidity_over_kbar}` directive to the `\begin{proof}` block of `nonempty_jacobianWitness` so the dependency graph registers the dependency.
  - `RigidityKbar.tex` does not preview whether `[IsAlgClosed kbar]` will need to be added when piece (iii) lands. Add a one-sentence remark in § "shared pile" piece (iii) clarifying that the body-closure may require strengthening the base-field hypothesis.
  - `Differentials.tex` Step 4.5 prose names `component_nontrivial` but the actual Lean proof uses `Nonempty V` + `algebraize`. Either tighten the prose to match the actual proof or verify `component_nontrivial` exists in Mathlib and refactor `Differentials.lean:139` to use it.
  - `Jacobian.tex` § C.2.d presents two proof routes (dual abelian variety + cotangent bundle); `RigidityKbar.tex` § "shared pile" commits to the cotangent route only. Reconcile when the body-closure plan is fixed (probably iter-129+).
  - **Orphan chapters cleanup**: `Modules_Monoidal.tex`, `Picard_LineBundle.tex`, `Picard_Functor.tex`, `Picard_FunctorAb.tex` are out-of-scope per STRATEGY.md's M2 routing. The iter-124, iter-125, and iter-126 reviewers have all flagged this. Dispatch a blueprint-writer for deletion this iter (low cost; one-line directive: "delete these four files; they are not in content.tex and are dead-route Picard-scheme material").
  - **Direct over-k rigidity coverage** — conditional on the iter-127 mathlib-analogist consult. If the consult endorses the path, dispatch a writer iter-128 to author a new chapter (`RigidityOverK.tex` or similar). If the consult rejects, no action.

- **informational**:
  - `RigidityKbar.tex` C.2.e wave-at-C.2.b prose (L55).
  - Underscored `_hgenus` / `_hf` Lean hypothesis names will be de-underscored when the body lands.
  - `RigidityKbar.tex` piece (i) framing: the "naming-idiom alignment per Yang+Merten 2026" reference is opaque to a reader without that context; could benefit from a one-line gloss on which Mathlib snapshot's `GrpObj` namespace is the target.

Overall verdict: **Build is gated on a blueprint-writer dispatch for `RigidityKbar.tex` piece (i) sub-decomposition** (mandatory this iter to satisfy iter-128's META-PATTERN TRIPWIRE); a smaller writer dispatch on `Jacobian.tex` to add the `genusZeroWitness` builder signature is recommended; orphan-chapter cleanup writer is optional but overdue. Multi-route coverage gap on the over-k alternative is conditional on the in-flight analogist consult — defer to iter-128.
