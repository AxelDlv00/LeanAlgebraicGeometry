# Blueprint Review Report

## Slug
iter105

## Iteration
105

## Top-level summaries

### Incomplete parts
- `Cohomology_MayerVietoris.tex` / § "Čech acyclicity and vanishing on affines" (lines 1110–1184): the proof sketch for `\thm:basicOpenCover_isCechAcyclicCover_toModuleKSheaf` (lines 1162–1170) is the classical four-step argument (local exactness → identification → extra-degeneracy contraction → globalization) and does NOT mention the engine that the iter-104/iter-105/iter-106 cycles actually built: `cechCofaceMap_summand_family`, `cechCofaceMap_summand_family'`, `cechCofaceMap_summand_family_R_linear`, `cechCofaceMap_summand_family'_R_linear`, `alternating_sum_pi_smul_aux`, `alternating_sum_pi_smul_aux_sum_comp`, `alternating_zsmul_pi_smul_aux_sum_comp`, and the iter-106 lemma signature `cechCofaceMap_summand_family_comp_eqToHom_eq_summand_family'`, plus the active target `cechCofaceMap_pi_smul`. The directive declares these project-local and not requiring `\lean{...}` entries, but the chapter has no prose pointing at "per-coface R-linearity" or the residual eqToHom-vs-`Pi.π` identification at coordinate `j'` (Lean L1179). Same status as iter-104; not addressed this iter.
- `Picard_LineBundle.tex`: chapter prose (lines 10–14) presents `\def:Scheme_LineBundle` as the geometric "invertible quasi-coherent sheaf" target, with `\leanok` and `\lean{AlgebraicGeometry.Scheme.LineBundle}`. The actual Lean definition at `AlgebraicJacobian/Picard/LineBundle.lean:85` is `def LineBundle (X : Scheme.{u}) : Type u := CommRing.Pic (X.presheaf.obj (op (⊤ : X.Opens)))`, whose own docstring (lines 33–56 and 71–84) admits it is a **strict subgroup** of the true Picard group on non-affine schemes (e.g. trivial for projective space whereas the true `Pic` is `ℤ`). The chapter does NOT flag this divergence; the C1 redefinition (per `STRATEGY.md` Phase C1) is queued, but nothing in `Picard_LineBundle.tex` itself records the current Lean-state mismatch — only `Picard_Functor.tex` § "Forward-compatibility note" (line 75) and `Modules_Monoidal.tex` line 72 acknowledge it. A reader of `Picard_LineBundle.tex` in isolation would assume the geometric definition is what Lean carries.

### Proofs lacking detail
- `Cohomology_MayerVietoris.tex` / `\thm:basicOpenCover_isCechAcyclicCover_toModuleKSheaf` (lines 1162–1170): Step 3 "Contraction by extra degeneracy" asserts the augmented complex admits an extra degeneracy without naming (a) the section map being constructed, (b) which simplicial-object API is used, or (c) how contraction descends to exactness of the unaugmented complex. A prover reading the prose cannot reconstruct the chain `cechCofaceMap_pi_smul → splitEpi_pi_lift_of_injective → cechCohomology_subsingleton_of_cechCochain_exactAt` from this text.
- `Cohomology_MayerVietoris.tex` / `\thm:Scheme_subsingleton_HModule_of_isCechAcyclicCover_top` (lines 775–788): proof sketch is "rewrite supremum to `\top`, transport across whole-space bridge". The `\uses{}` cites `def:Scheme_HModule_eq_HModule_prime_linearEquiv` (broken — see Cross-chapter notes). Without naming the bridge correctly, the prover cannot follow the transport direction.
- `Cohomology_StructureSheafModuleK.tex` / `\thm:Scheme_subsingleton_HModule_prime_supr_of_isCechAcyclicCover` (lines 625–637): proof sketch is one line ("Transport the subsingleton structure along the symmetric form of the comparison isomorphism") and gives no detail on which comparison the hypothesis carries. The `\uses{}` cites `def:Scheme_HModule'` (broken — see Cross-chapter notes).
- `Modules_Monoidal.tex` / `\thm:Modules_MonoidalCategory` (lines 33–53): proof block describes the `LocalizedMonoidal` strategy but the load-bearing `W.IsMonoidal` hypothesis is split off into the `[Status of $W$.IsMonoidal …]` remark (lines 59–61) and is not named anywhere via `\lean{instIsMonoidal_W}`. A prover wanting to chase the upstream Mathlib gap would need to grep the Lean source.

### Lean difficulty quality
- `Cohomology_MayerVietoris.tex` / `\thm:Scheme_basicOpenCover_supr_of_span_eq_top` (line 956): hint `\lean{AlgebraicGeometry.Scheme.basicOpenCover_supr_of_span_eq_top}` — prose says "spans the unit ideal" but does not pin (a) whether `s` is `Set`/`Finset`/`Subset`, (b) whether the predicate is `Ideal.span = ⊤` / `Submodule.span ⊤` / `Ideal.IsUnit`, (c) whether the conclusion is `iSup = ⊤` or set-theoretic union. Prover has to guess.
- `Cohomology_MayerVietoris.tex` / `\def:Scheme_splitEpi_pi_lift_of_injective` (lines 1119–1135): hint `\lean{AlgebraicGeometry.Scheme.splitEpi_pi_lift_of_injective}` — prose says "Let `{M_α}` be a family of `k`-modules and `f : B → A` injective… the projection admits a section". The signature is ambiguous: prover has no way to infer from the prose whether `M : A → ModuleCat k`, whether the projection is into `ModuleCat k` or `Type`, or which retraction is used.
- `Cohomology_MayerVietoris.tex` / `\def:Scheme_HasCechToHModuleIso` (line 809–815): hint `\lean{AlgebraicGeometry.Scheme.HasCechToHModuleIso}` — statement "the existence of a `k`-linear comparison isomorphism… in every degree". The Prop-class vs structure-class shape is not pinned; if the prover instantiates the wrong shape, downstream existence producers will not fire.
- `Cohomology_MayerVietoris.tex` / `\thm:Scheme_HModule_prime_sequenceIso` (line 357) and `\thm:Scheme_HModule_prime_sequence_exact` (line 371): the comparison and sequence are described componentwise but the `Composable` 5-tuple vs hand-rolled tuple choice is not pinned. (Both carry `\leanok` so the Lean side has resolved this; only mentioned as informational.)
- `Differentials.tex` / `\thm:cotangent_exact_sequence` (line 137–151): hint `\lean{AlgebraicGeometry.Scheme.cotangent_exact_sequence}` — statement gives the three-term exact sequence in prose but does not pin the target API shape (`ShortComplex` vs `LongExact` vs hand-rolled). Prover guessing from prose alone may produce a structurally different statement than the one expected downstream.

### Multi-route coverage
- Route "single Phase A active = `cechCofaceMap_pi_smul` closure (L1179, Route 1 lemma `cechCofaceMap_summand_family_comp_eqToHom_eq_summand_family'` proved via `Pi.hom_ext` + per-coord `Pi.lift_π_apply` match + `Fin.cast_cast` roundtrip; Route 3 in-place `convert h_wrap_pt using N` as fallback)": PASS — the directive states a single strategic route. Tactical Route 1 vs Route 3 are tactic choices, not blueprint-level routes. The blueprint contains the surrounding scaffolding; the lack of prose for the named-family engine is the same observation as iter-104.
- Route "Phase C3 representability — (a) FGA-Hilbert vs (b) Sym^g/S_g": PASS — `Picard_Functor.tex` Step C3 (line 43) names both routes, calls out their Mathlib prerequisites, and defers the choice to Step C2. Both routes are documented in the blueprint.

## Per-chapter

### blueprint/src/chapters/AbelJacobi.tex
- **complete**: true
- **correct**: true
- **notes**:
  - All three protected declarations (`ofCurve`, `comp_ofCurve`, `exists_unique_ofCurve_comp`) have `\lean{...}` hints matching `archon-protected.yaml`. Proof sketches reduce cleanly to `nonempty_jacobianWitness` + `IsAlbanese.unique`.

### blueprint/src/chapters/Cohomology_MayerVietoris.tex
- **complete**: partial
- **correct**: partial
- **notes**:
  - **wrong (broken cross-ref)** — line 779 `\thm:Scheme_subsingleton_HModule_of_isCechAcyclicCover_top` `\uses{… def:Scheme_HModule_eq_HModule_prime_linearEquiv, …}` references a label that does **not exist anywhere in the blueprint** (verified via Grep). The reverse-direction label `def:Scheme_HModule_prime_eq_HModule_linearEquiv` exists at line 644; this is almost certainly a typo for the forward direction. Iter-104 already flagged this; still unfixed. Silently corrupts the dependency graph between Čech acyclicity and the cover-totality bridge.
  - **missing** — no prose section/subsection in § "Čech acyclicity" (sec:basic_open_acyclicity, lines 1110–1184) documents the iter-104/iter-105/iter-106 `cechCofaceMap_*_family` engine (named family + wrapper + R-linearity transport + alternating-sum helpers + iter-106 Route 1 lemma signature). Per directive these are project-local helpers without need for `\lean{...}`, but the proof sketch of `\thm:basicOpenCover_isCechAcyclicCover_toModuleKSheaf` does not even mention "per-coface R-linearity" or "alternating-sum decomposition" — the active sub-obligation (eqToHom-vs-`Pi.π` identification at coord `j'`, Lean L1179) is invisible to a blueprint reader.
  - **vague** — line 1137 `\thm:Scheme_cechCohomology_subsingleton_of_cechCochain_exactAt` proof sketch is one sentence; the actual Lean closure pulls `splitEpi_pi_lift_of_injective` + `IsCechAcyclicCover` machinery and the prose does not preview that.
  - **observation** — `\def:Scheme_AffineCoverMVSquare_HModule_prime_sequence_curve` (line 533) `\uses{def:Scheme_toModuleKSheaf}` references a label in `Cohomology_StructureSheafModuleK.tex` (cross-chapter). Valid; worth confirming once plastex regenerates.
  - **observation** — `\thm:Scheme_cechCohomology_subsingleton_of_cechCochain_exactAt` (line 1137) and `\def:Scheme_splitEpi_pi_lift_of_injective` (line 1119) have `\lean{...}` hints but no `\uses{}` block (only `\leanok`). Not strictly required by the blueprint conventions, but inconsistent with neighbouring blocks.

### blueprint/src/chapters/Cohomology_SheafCompose.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Single-theorem chapter (`instHasSheafCompose_forget_CommRing_AddCommGrp`); statement and "limits-create composition" proof sketch are adequate.

### blueprint/src/chapters/Cohomology_StructureSheafAb.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Three pieces (`HasSheafify`, `HasExt`, `toAbSheaf`) line up with the corresponding Lean instances. Proof sketches are short but adequate ("instance inferable, only universe pinning").

### blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex
- **complete**: partial
- **correct**: partial
- **notes**:
  - **wrong (broken cross-ref)** — line 629 `\thm:Scheme_subsingleton_HModule_prime_supr_of_isCechAcyclicCover` `\uses{def:Scheme_IsCechAcyclicCover, def:Scheme_HModule'}` — the label `def:Scheme_HModule'` does **not exist anywhere in the blueprint** (verified via Grep). The correct label is `def:Scheme_HModule_prime` (line 259 of this same file). Pure typo, but the dependency-graph corruption it causes is real. Iter-104 already flagged this; still unfixed.
  - **observation** — 655-line chapter; covers Phase A step 5 plus the Čech scaffolding handoff to `Cohomology_MayerVietoris.tex`. The bulk of the chapter is well-formed.

### blueprint/src/chapters/Differentials.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - **observation** — `\lem:cotangent_exact_structure` (line 77) proof block explicitly captures the iter-086+iter-087 deferral of `case h_exact` as "deferred upstream parallel to `instIsMonoidal_W`" with a long `% NOTE` block (lines 93–96). Matches the directive's status note.
  - **observation** — `\lem:sheafOfModules_exact_iff_stalkwise` (line 105) is labelled "mathematical statement only; not formalised" with no `\lean{...}` hint and a `% NOTE` explaining the absence. Correct framing.
  - **vague** — `\thm:cotangent_exact_sequence` (line 137) is two sentences and does not pin the target API shape. Prover would benefit from an explicit hint at the expected Lean signature (`ShortComplex` vs hand-rolled). Not active route this iter, so this is informational.

### blueprint/src/chapters/Genus.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Protected declaration `\def:genus` matches `AlgebraicGeometry.genus`. `\noncomputable` authorization is recorded in §2. Three reformulations (Serre duality, χ, topological genus) flagged as future work.

### blueprint/src/chapters/Jacobian.tex
- **complete**: true
- **correct**: true
- **notes**:
  - All five protected declarations (`Jacobian`, `instGrpObj`, `smoothOfRelativeDimension_genus`, `instIsProper`, `instGeometricallyIrreducible`) have `\lean{...}` hints matching `archon-protected.yaml`. The bundled-hypothesis route via `nonempty_jacobianWitness` is documented with the Pic-scheme / Sym^g / rigidity alternatives.

### blueprint/src/chapters/Modules_Monoidal.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - **observation** — `\thm:Modules_MonoidalCategory` (line 33) statement and proof both carry `\leanok`. This is accurate: only `instIsMonoidal_W` (`Modules/Monoidal.lean` L173) carries a sorry; `instMonoidalCategory` and `instMonoidalCategoryStruct` are closed via `inferInstanceAs (LocalizedMonoidal …)`.
  - **observation** — the `[Status of $W$.IsMonoidal …]` remark (line 59) captures the C0 deferral cleanly in prose. No `\lean{...}` entry for `instIsMonoidal_W` itself, which is acceptable (not protected, project-local helper). However, the chapter never names `instIsMonoidal_W` in `\texttt{...}` form so a prover attacking the upstream Mathlib gap has to grep the Lean source to discover the name.

### blueprint/src/chapters/Picard_Functor.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - **observation** — `\thm:Pic_representable` (line 28) is intentionally left as a deferred sorry; the proof block reduces it to Phase C steps C0–C3 with both routes (FGA-Hilbert and Sym^g/S_g) named.
  - **observation** — "Forward-compatibility note (LineBundle approximation)" subsection (line 75) explicitly acknowledges the C1 LineBundle refactor required before `representable` can be honestly closed. Good gating documentation — this is the place where the Lean-side approximation IS flagged (unlike `Picard_LineBundle.tex` itself).

### blueprint/src/chapters/Picard_FunctorAb.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Definition and forget-and-recover compatibility lemmas match `AlgebraicGeometry.Scheme.PicardFunctorAb*` declarations. The étale-sheafification is correctly framed as definition-only (no representability claim).

### blueprint/src/chapters/Picard_LineBundle.tex
- **complete**: partial
- **correct**: partial
- **notes**:
  - **wrong (Lean-state mismatch)** — `\def:Scheme_LineBundle` (line 10) presents the geometric "invertible quasi-coherent `O_X`-module … invertible w.r.t. tensor product in the symmetric monoidal category" definition as the target of `\lean{AlgebraicGeometry.Scheme.LineBundle}`. The actual Lean code at `AlgebraicJacobian/Picard/LineBundle.lean:85` is `CommRing.Pic (X.presheaf.obj (op (⊤ : X.Opens)))` (the Picard group of the global-sections ring). The Lean file's own docstring (lines 33–56 + 71–84) admits this is a **strict subgroup** of the true Picard group on non-affine schemes (explicitly: "trivial for projective space whereas the true Pic is `ℤ`"). The C1 refactor scheduled in `STRATEGY.md` plans to replace this body with `MonoidalCategory.Invertible` of `X.Modules`. The chapter prose presents the post-C1 target as if it were the current state. The downstream chapters `Picard_Functor.tex` (line 75) and `Modules_Monoidal.tex` (line 72) acknowledge the approximation; `Picard_LineBundle.tex` itself does not.
  - **observation** — `\thm:Scheme_Pic_commGroup` (line 23) and `\thm:Scheme_Pic_pullback` (line 40) carry `\leanok` markers, which are accurate for the **current approximation-level Lean code** (the global-sections `CommRing.Pic` carries a canonical group structure and contravariant functoriality), but the prose for both theorems describes the **geometric/post-C1 target** ("tensor product over `O_X`", "Pull-back of `O_Y`-modules along `f`"). When C1 lands, the proofs change substantively even though the statements remain true; if a prover or reader treats the current `\leanok`s as binding "the geometric statement is formalized", they will be misled.
  - Per directive: the C1 refactor is queued ("Phase C1 plans to refactor this to `Invertible` of `X.Modules`"). The chapter should reflect that the current Lean state is the approximation, the chapter's geometric definition is the target. This needs at least a `% NOTE` / status block. The lean-auditor-iter104 CRITICAL finding (admitted-wrong on non-affine schemes by its own docstring) is real and not yet surfaced in this chapter.

### blueprint/src/chapters/Rigidity.tex
- **complete**: true
- **correct**: true
- **notes**:
  - `\thm:GrpObj_eq_of_eqOnOpen` matches the Lean declaration. Proof sketch lists every Mathlib ingredient needed (proper ⇒ separated; equaliser-is-closed; geometric irreducibility ⇒ irreducible underlying space; smoothness ⇒ regularity ⇒ reducedness; group-object structure for the difference morphism; etc.) and frames the lemma as standalone (no Picard/Jacobian dependency). The "Mathlib ingredients" enumeration remains the strongest in the blueprint.

## Cross-chapter notes

- **Broken `\uses{}` #1** — `Cohomology_MayerVietoris.tex:779` references `def:Scheme_HModule_eq_HModule_prime_linearEquiv` (does **not exist**, verified globally via Grep). Intended target is plausibly `def:Scheme_HModule_prime_eq_HModule_linearEquiv` (defined at line 644 of the same file), the **reverse-direction** label. The directionality reversal matters for the dependency graph because the proof transport runs left-to-right on the type. Either fix the `\uses` to use the existing reverse label, or add a missing forward-direction definition. Iter-104 already flagged this; the fix did not land. Re-confirmed iter-105.
- **Broken `\uses{}` #2** — `Cohomology_StructureSheafModuleK.tex:629` references `def:Scheme_HModule'` (does **not exist**, verified globally). Correct label is `def:Scheme_HModule_prime` (line 259 of the same file). Pure typo. Iter-104 already flagged this; the fix did not land. Re-confirmed iter-105.
- **No `\lean{...}` for `cechCofaceMap_*_family` helpers** — Per directive these are project-local helpers; lack of entries is acceptable. The deeper issue is that no proof prose anywhere in `Cohomology_MayerVietoris.tex` documents the named-family decomposition that the iter-104/iter-105 prover cycles built and that the iter-106 lemma signature extends. A blueprint-writer dispatch (already queued in `STRATEGY.md` "Iter-107+ if iter-106 closes L1179") will eventually need to land a single consolidated paragraph in § Čech acyclicity describing the engine.
- **`Modules_Monoidal.tex` ↔ `Differentials.tex`** — `Modules_Monoidal.tex` describes the C0 strategy in terms of `W.IsMonoidal`; `Differentials.tex` line 93 cross-references the C0 deferral as "parallel to `instIsMonoidal_W`". Naming is consistent but a reader of `Modules_Monoidal.tex` cannot immediately identify which Lean declaration is the deferred sorry. The `[Status of $W$.IsMonoidal …]` remark (line 59) would benefit from a one-line `\texttt{instIsMonoidal\_W}` mention.
- **`Picard_LineBundle.tex` ↔ `Picard_Functor.tex` / `Modules_Monoidal.tex` Lean-state divergence** — `Picard_LineBundle.tex` presents the geometric/post-C1 target definition; `Picard_Functor.tex` § "Forward-compatibility note" (line 75) and `Modules_Monoidal.tex` line 72 both acknowledge that the current Lean side uses the `CommRing.Pic Γ(X,⊤)` approximation. The acknowledgement belongs in `Picard_LineBundle.tex` itself (the chapter that owns the affected `\lean{...}` hint) as a `% NOTE` or status block, not only in the consuming chapters.

## Strategy-modifying findings (if any)

None. The directive flags the C1 LineBundle refactor (current Lean def admitted-wrong on non-affine schemes by its own docstring) as already scheduled in `STRATEGY.md` Phase C1; this iter's `Picard_LineBundle.tex` failure to flag the mismatch is a chapter-rewrite finding, not a strategy modification. The blueprint is consistent with the strategy at the level of strategic routes (single Phase A target; Phase C0 deferral acknowledged; Phase C3 dual routes both documented).

## Severity summary

Applying the canonical severity rules verbatim:

- **must-fix-this-iter** (3 findings):
  1. **Broken `\uses{}` cross-reference** at `Cohomology_MayerVietoris.tex:779` (`def:Scheme_HModule_eq_HModule_prime_linearEquiv` does not exist). Per the rule "Broken `\uses{}` cross-references that point at non-existent labels — these silently corrupt the dependency graph and must be fixed before provers downstream of them run." Iter-104 flagged; still unfixed.
  2. **Broken `\uses{}` cross-reference** at `Cohomology_StructureSheafModuleK.tex:629` (`def:Scheme_HModule'` does not exist; correct is `def:Scheme_HModule_prime`). Same rule. Iter-104 flagged; still unfixed.
  3. **`Picard_LineBundle.tex` is `correct: partial`** because the chapter prose (`\def:Scheme_LineBundle`) describes the geometric/post-C1 target while the actual Lean side carries the global-sections approximation (admitted-wrong on non-affine schemes by its own docstring). Per the rule "Any chapter has `complete: partial | false` OR `correct: partial | false` — even if the strategy 'does not require' that chapter this iter. A `partial` chapter cannot be relied on by any prover; a blueprint-writer must be dispatched." This chapter's `\lean{AlgebraicGeometry.Scheme.LineBundle}` hint, plus the two `\leanok`-marked theorems whose proofs change under C1, are silently misleading.

  Additionally `Cohomology_MayerVietoris.tex` and `Cohomology_StructureSheafModuleK.tex` are themselves `partial` on the correctness axis (because of the broken `\uses{}` items above). Under the strict reading of the rule, those chapter `partial` flags ALSO trigger must-fix; both findings are subsumed by the broken-cross-ref entries above, which is the actual fix the writer needs to make.

  **Gate impact on Phase A active target (`BasicOpenCech.lean` → `Cohomology_MayerVietoris.tex`)**: this chapter is `correct: partial`, so per the dispatcher rule the prover should be **deferred** this iter and a blueprint-writer dispatched to fix the broken `\uses{}` plus (optionally) land the missing `cechCofaceMap_*_family` engine prose. Note: the broken `\uses{}` at L779 affects the `\thm:Scheme_subsingleton_HModule_of_isCechAcyclicCover_top` chain in `sec:cech_acyclicity_consumption` (downstream of basic-open infra), not directly the L1179 obligation; a softer reading is that the broken reference does not strictly block L1179 work. The plan agent makes the call; I flag the rule application strictly.

- **soon** (5 findings):
  1. `Cohomology_MayerVietoris.tex` § "Čech acyclicity" missing prose documentation for the `cechCofaceMap_*_family` engine + active L1179 obligation (Route 1 lemma + per-coord identification). Independent of the broken-`\uses` fixes; will be addressed when iter-106 closes L1179 (per STRATEGY.md "Iter-107+ if iter-106 closes L1179").
  2. `Modules_Monoidal.tex` `[Status of $W$.IsMonoidal …]` remark missing `\texttt{instIsMonoidal\_W}` name pinning.
  3. `Cohomology_MayerVietoris.tex` / `\thm:basicOpenCover_isCechAcyclicCover_toModuleKSheaf` Step 3 prose insufficient to reconstruct the contraction.
  4. `Cohomology_StructureSheafModuleK.tex` / `\thm:Scheme_subsingleton_HModule_prime_supr_of_isCechAcyclicCover` one-line proof sketch.
  5. `Cohomology_MayerVietoris.tex` / `\thm:Scheme_cechCohomology_subsingleton_of_cechCochain_exactAt` and `\def:Scheme_splitEpi_pi_lift_of_injective` missing `\uses{}` blocks (`\leanok` present, structurally inconsistent with neighbours).

- **informational** (5 findings):
  1. `splitEpi_pi_lift_of_injective` signature underspecified in prose (Lean target quality).
  2. `HasCechToHModuleIso` Prop-class vs structure-class shape unspecified (Lean target quality).
  3. `basicOpenCover_supr_of_span_eq_top` predicate shape and conclusion shape unspecified (Lean target quality).
  4. `cotangent_exact_sequence` (`Differentials.tex` line 137) API-shape pinning missing — not active route this iter.
  5. `HModule_prime_sequenceIso` / `HModule_prime_sequence_exact` 5-tuple API-shape pinning — already resolved on Lean side (both carry `\leanok`); informational only.

Overall verdict: 3 must-fix items live this iter (2 broken `\uses{}` re-confirmed from iter-104; 1 `Picard_LineBundle.tex` Lean-state mismatch surfaced by the lean-auditor-iter104 critical finding). Phase A prover dispatch on `BasicOpenCech.lean` is strictly gated by the `Cohomology_MayerVietoris.tex` `correct: partial` flag; a softer reading exempts L1179 work since the broken `\uses` is downstream of basic-open infra rather than co-located with it.
