# Blueprint Review Report

## Slug
route173

## Iteration
173

## Top-level summaries

### Incomplete parts
- `AbelianVarietyRigidity.tex`: three scaffold-sorry helpers `gmScalingP1_chart`, `gmScalingP1_chart_agreement`, `gmScalingP1_over_coherence` (cited inside the NOTE block of `def:gaTranslationP1` at L1213–1219 and L1276–1277) appear ONLY inside TeX comments — they have **no top-level `\begin{lemma}…\lean{…}\end{lemma}` declaration blocks** of their own. Confirms iter-172 `g0bo172` finding. Without per-decl pins, the blueprint-doctor cannot statically link the Lean scaffolds (`AlgebraicGeometry.gmScalingP1_chart`, `gmScalingP1_chart_agreement`, `gmScalingP1_over_coherence` in `Genus0BaseObjects.lean`) to their blueprint specification, and the next prover that resolves any of these three has no informal target to read.
- `Jacobian.tex` L344, L384–390, L425–427: A.4 row prose still says "~900–1200 LOC, ~7–11 iters" and "(A.4) → no new Mathlib namespace; reuses AlgebraicJacobian.AbelianVarietyRigidity (in tree, axiom-clean) + Mathlib's Albanese-style universal property machinery", contradicting the iter-172 audit at L574–602 (audit outcome (b), bypass FAILS — Lemma 3.3 codim-1 Weil-divisor / Auslander–Buchsbaum sub-build required) and L656 ("The STRATEGY.md A.4 row claim ‘no new Mathlib namespace’ is incorrect with respect to this Lemma 3.3 sub-build"); STRATEGY.md also has A.4 at ~22–35 iters now. Confirms iter-172 `jacobian172` finding.
- `RiemannRoch_WeilDivisor.tex`: chapter under-specifies (i) the prime-divisor data structure — no Mathlib predicate or project encoding is named for "codim-1 prime / Hartshorne $(*)$"; the in-tree `Scheme.PrimeDivisor` carries a placeholder `isCodim1AndIntegral : True := trivial`, which the chapter only discloses inside a NOTE comment of `def:codim1_cycles` (not in the prose), and (ii) the hypothesis sets on `degree`, `principal`, and `ofClosedPoint` — the prose says "smooth proper curve over an algebraically closed field $\bar k$" and "$X$ satisfies $(*)$" abstractly, but does not enumerate which Lean instances those hypotheses spell to, so the prover has no target shape to match. Confirms iter-172 `wd172` finding.

### Lean difficulty quality
- `AbelianVarietyRigidity.tex` / scaffolds `gmScalingP1_chart{,_agreement,_over_coherence}` referred-to in NOTE prose at L1213–1219, L1276–1277: each is on the active genus-0 prover lane (Lane A's `Genus0BaseObjects.lean` body for `gmScalingP1`), so the missing pin is HARD GATE-blocking until the writer dispatch adds them.
- `RiemannRoch_WeilDivisor.tex` / `\lean{AlgebraicGeometry.Scheme.WeilDivisor.degree_hom}`: chapter prose at L228–254 does not specify whether `degree_hom` is bundled as an `AddMonoidHom`, a plain function plus additivity lemma, or something else; Lean signature is `X.WeilDivisor →+ ℤ` over an arbitrary `{X : Scheme.{u}}` with NO `[IsAlgClosed kbar]` instance, whereas the prose specialises to "$C$ smooth proper curve over $\bar k$". Mismatch on hypothesis surface. Lane C (WeilDivisor.lean) prover needs the chapter to pick one. HARD-gate-blocking for the iter-173 `degree_hom` body lane.
- `RiemannRoch_WeilDivisor.tex` / `\lean{AlgebraicGeometry.Scheme.WeilDivisor.ofClosedPoint}`: chapter prose at L182–197 names "closed point $P \in C$" but does NOT specify the closedness-witness shape; Lean uses `(_hP : IsClosed ({P} : Set C))` with `P : C`. The chapter should pin this Lean-side encoding (or recommend a refactor to `(P : C.closedPoints)` / `IsClosedPoint` package) so the iter-173 body work has an unambiguous target.

### Citation discipline
- `Picard_RelativeSpec.tex` / `thm:relative_spec_univ`: the `% SOURCE QUOTE PROOF:` block at L185–190 reads "TODO retrieve from references/stacks-constructions.tex (proof of lemma-spec, L553–600, …). Verbatim quote omitted for length; the structural steps are restated below in project notation." — the verbatim quote is missing. Citation-discipline rule requires the source proof quote when the proof prose derives from the cited source (and this proof's first sentence is "Following Stacks tag 01LQ (proof of lemma-spec)…"). Likely fixable by retrieving the proof body of Stacks lemma-spec from `references/stacks-constructions.tex` and pasting verbatim. This block currently feeds the iter-173 RelativeSpec prover lane via `\lean{AlgebraicGeometry.Scheme.RelativeSpec.UniversalProperty}` (one of the named pins), so flag as **must-fix-soon** rather than informational.
- `Picard_RelativeSpec.tex`: all four `(read from references/stacks-constructions.tex, L###-L###)` parentheticals name a file that does exist on disk (verified). No fabrication.
- `RigidityKbar.tex` / `thm:rigidity_over_kbar` L59–63: `% SOURCE: Mumford, Abelian Varieties, Ch. II §4 (verbatim text not yet retrieved — paywalled, no open copy in references/). No SOURCE QUOTE is supplied: the source is not bundled and recalled text must not be substituted (citation discipline).` This is a self-disclosed citation gap. Since the chapter is the fallback route (a) and no longer feeds an active prover lane, classify as informational. Recommendation: replace the `% SOURCE:` line with a project-bespoke marker (no external source) referencing the parallel `\cref{thm:rigidity_genus0_curve_to_AV}` of `AbelianVarietyRigidity.tex`, which IS the active keystone.

### Multi-route coverage
- Route C (committed) — Milne §I.3 rigidity completion, genus-0 base case via `𝔾_m`-scaling shortcut: PASS — fully covered in `AbelianVarietyRigidity.tex` (1750 LOC, 19+ declaration blocks).
- Route A — Picard scheme via FGA: PARTIAL — the four sub-rows (A.1.a–A.4) are documented in `Jacobian.tex` § "Existence of an Albanese variety" and § "Route A.4", and A.1.a now has its dedicated chapter `Picard_RelativeSpec.tex` (landed iter-172). Sub-rows A.1.b, A.1.c, A.2.a, A.2.b, A.2.c have NO dedicated chapter; A.3 has none beyond the Jacobian.tex paragraph; A.4 is in Jacobian.tex §A.4 with the iter-172 audit. See `## Unstarted-phase blueprint proposals`.
- Genus-0 RR bridge — Hartshorne IV.1.3.5: PARTIAL — RR.1 (WeilDivisor) has its dedicated chapter `RiemannRoch_WeilDivisor.tex` (landed iter-171); RR.2, RR.3, RR.4 have NO dedicated chapter. See `## Unstarted-phase blueprint proposals`.
- Fallback Route (a) — differential / Serre-duality: PASS for coverage (it is documented as the off-critical-path fallback in `RigidityKbar.tex`); not feeding any active lane.

## Unstarted-phase blueprint proposals

### Proposed chapter: `blueprint/src/chapters/Picard_LineBundlePullback.tex`

**Covers**: `AlgebraicJacobian/Picard/LineBundlePullback.lean` (new file)
**Strategy phase**: Route A.1.b — `LineBundle.Pullback` on `C ×_k T`
**Why now**: Highest-leverage parallel-startable Route-A chapter — its `\uses{}` graph is rooted in `Picard_RelativeSpec.tex` (landed iter-172) and Mathlib's existing line-bundle / pullback infrastructure; once written, the prover lane for the `.lean` file-skeleton can open immediately (estimated ~2–4 iters). Without it, A.1.c (RelPicFunctor) and consequently all of A.2.* / A.3 / A.4 cannot proceed.

**Key declarations** (in dependency order):
1. `\definition` `\label{def:line_bundle_on_product}` — A line bundle on a product $C \times_k T$ is an invertible $\mathcal O_{C \times_k T}$-module. `\lean{AlgebraicGeometry.Scheme.LineBundle.OnProduct}` [expected]. Source: Hartshorne II §6 (re-export of `Mathlib.AlgebraicGeometry.LineBundle` or `Mathlib.AlgebraicGeometry.Modules.Invertible`).
2. `\definition` `\label{def:pullback_along_projection}` — The pullback functor $\pi_T^* \colon \mathrm{Pic}(T) \to \mathrm{Pic}(C \times_k T)$ along the projection $\pi_T \colon C \times_k T \to T$. `\lean{AlgebraicGeometry.Scheme.LineBundle.pullbackAlongProjection}` [expected]. Source: Stacks tag 01HH (preservation of invertibility under pullback) + Hartshorne II §7.
3. `\lemma` `\label{lem:pullback_compose}` — $\pi_T^* \circ \pi_{T'}^* = (\pi_T \circ \pi_{T'})^*$ on line bundles. `\lean{AlgebraicGeometry.Scheme.LineBundle.pullback_pullback_eq}` [expected]. Source: standard / Stacks tag 01HG.
4. `\theorem` `\label{thm:relative_pic_quotient_well_defined}` — The relative Picard presheaf $\mathrm{Pic}^\sharp_{C/k}(T) := \mathrm{Pic}(C \times_k T) / \pi_T^* \mathrm{Pic}(T)$ is a well-defined functor (additivity of quotient by a subgroup). `\lean{AlgebraicGeometry.Scheme.RelPicPresheaf.preimage_subgroup}` [expected]. Source: Kleiman §2 (`references/kleiman-picard.md`).
5. `\theorem` `\label{thm:pullback_natural}` — For a morphism $g : T' \to T$ over $k$, the pullback functor $g^*$ on $\mathrm{Pic}(C \times_k T)$ descends through the quotient. `\lean{AlgebraicGeometry.Scheme.RelPicPresheaf.functorial}` [expected]. Source: Kleiman §2 + Stacks 01HG.

**`\uses` skeleton**:
- `def:pullback_along_projection` uses `def:line_bundle_on_product`
- `lem:pullback_compose` uses `def:pullback_along_projection`
- `thm:relative_pic_quotient_well_defined` uses `def:pullback_along_projection`
- `thm:pullback_natural` uses `def:pullback_along_projection`, `lem:pullback_compose`, `thm:relative_pic_quotient_well_defined`

**Main theorem proof strategy**: The pullback-and-quotient construction reduces to two Mathlib-side facts: (i) pullback of an invertible sheaf along a morphism of schemes is invertible (`Mathlib.AlgebraicGeometry.Modules.Invertible` and `Mathlib.AlgebraicGeometry.PullbackScheme.Pullback.{lift_of_invertible,instance_isInvertible}`); (ii) the resulting pullback functor is exact on the Picard group (`KaehlerDifferential.compatibilities` analogue). Naturality in $T$ then follows from the base-change functoriality of pullback (Stacks 01HG); the quotient-of-functors construction is `CategoryTheory.Functor.subgroupQuotient` (or a Mathlib analogue) applied to the kernel-of-pullback subgroup.

**References for writer**:
- `references/kleiman-picard.md` (`kleiman-picard.tex`), §2 ("The Picard functor") — defines the relative Picard presheaf and the quotient by $\pi^* \mathrm{Pic}(T)$.
- `references/fga-explained.md`, Chapter 9 (Picard schemes) — high-level discussion of the relative Picard formalism.
- `references/stacks-constructions.tex` §"Line bundles" (tags 01HG–01HK) — Mathlib-flavoured pullback identities.

**Subphase choices exposed**:
- **Set-valued vs. group-valued presheaf**: Define $\mathrm{Pic}^\sharp_{C/k}$ as a `Functor (Scheme/k)ᵒᵖ Set` (forgetful, simpler) or as `Functor (Scheme/k)ᵒᵖ AddCommGrp` (carries the group structure, slightly heavier). Recommendation: **Set-valued for this chapter**, with the group refinement in a follow-up `Picard_RelPicFunctor.tex` (A.1.c) — keeps A.1.b small and lets the group structure depend on A.1.c's étale-sheafification step rather than re-doing it here.

---

### Proposed chapter: `blueprint/src/chapters/Picard_FGA_FlatteningStratification.tex`

**Covers**: `AlgebraicJacobian/Picard/FGAFlatteningStratification.lean` (new file)
**Strategy phase**: Route A.2.a — Flattening stratification of a coherent sheaf
**Why now**: STRATEGY.md explicitly tags this row as parallel-startable (no project-side gate). The Mathlib piece is Stacks 052H, absent from Mathlib; landing it as a project sub-build unblocks A.2.b (Quot representability) which is the dominant cost of Route A (~15–25 iters). The blueprint is independent of Picard_RelativeSpec; writing it now lets a prover lane open in parallel with the A.1.b/RR.2 lanes.

**Key declarations** (in dependency order):
1. `\definition` `\label{def:flat_locus}` — The flat locus of a coherent sheaf $\mathcal F$ on a morphism $f : X \to S$ is the open subset of $S$ over which $\mathcal F$ is $f$-flat. `\lean{AlgebraicGeometry.Scheme.flatLocus}` [expected]. Source: Stacks tag 0532.
2. `\definition` `\label{def:flatteningStratification}` — The flattening stratification of $\mathcal F$ is a locally-finite stratification of $S$ by locally closed subschemes such that the pullback of $\mathcal F$ to each stratum is flat. `\lean{AlgebraicGeometry.Scheme.flatteningStratification}` [expected]. Source: Stacks tag 052H (`references/stacks-coherent.md`).
3. `\theorem` `\label{thm:flatteningStratification_exists}` — For $f : X \to S$ proper finitely presented and $\mathcal F$ coherent on $X$, the flattening stratification of $S$ exists. `\lean{AlgebraicGeometry.Scheme.exists_flatteningStratification}` [expected]. Source: Stacks 052H.
4. `\theorem` `\label{thm:flatteningStratification_universal}` — The flattening stratification represents the functor "$T \mapsto \{$morphisms $T \to S$ along which $\mathcal F$ pulls back flat$\}$". `\lean{AlgebraicGeometry.Scheme.flatteningStratification_isUniversal}` [expected]. Source: Stacks 052H + Nitsure §4.

**`\uses` skeleton**:
- `thm:flatteningStratification_exists` uses `def:flat_locus`, `def:flatteningStratification`
- `thm:flatteningStratification_universal` uses `thm:flatteningStratification_exists`

**Main theorem proof strategy**: The existence proof is Stacks 052H, which combines: (i) generic flatness over a reduced base (Stacks 0552 — already partially in Mathlib via `Module.Flat` for the algebra-level case), (ii) Noetherian induction on $S$ to remove the reducedness assumption, (iii) the Tor characterization of flatness (Tor⁻¹ = 0 ⇒ flat — Mathlib has `Module.Tor`). The universal property is a Yoneda argument: a morphism $T \to S$ landing in the open stratum corresponds to a flat pullback. The dominant difficulty is the Noetherian induction (Stacks 0552 → 052H) and the locally-finite-stratification packaging, neither of which Mathlib supplies.

**References for writer**:
- `references/stacks-coherent.md` (`stacks-coherent.tex`), tags 0552 / 052H / 0533 (generic flatness, flattening stratification, flat locus).
- `references/nitsure-hilbert-quot.md`, §4 ("Generic flatness and the flattening stratification") — Nitsure's exposition.
- `references/fga-explained.md`, Chapter 5 (Quot schemes preliminaries).

**Subphase choices exposed**:
- **Coherent vs finitely presented**: state the existence theorem for "coherent on $X$" (Mathlib `CoherentlyOf`) vs "of finite presentation" (Mathlib `Sheaf.FinitePresentation`). Mathlib snapshot `b80f227` has both predicates but they diverge for non-Noetherian bases. Recommendation: **coherent on $X$**, with $X \to S$ assumed proper-of-finite-presentation (matching Nitsure §4's exact hypothesis). A note in §"Variants" can cover the f.p. case.
- **Locally-finite stratification API**: depend on a new project-bespoke `Scheme.LocallyClosedStratification` type, or piecewise-define via the "open stratum + locally-finite-by-induction" recipe. Recommendation: **define the project-bespoke type first** (in `Mathlib.AlgebraicGeometry.LocallyClosedStratification`) — this is a candidate Mathlib upstream PR that other consumers will want.

---

### Proposed chapter: `blueprint/src/chapters/RiemannRoch_RRFormula.tex`

**Covers**: `AlgebraicJacobian/RiemannRoch/RRFormula.lean` (new file)
**Strategy phase**: Genus-0 RR.2 — Riemann–Roch formula for genus 0
**Why now**: Highest-leverage parallel-startable RR-bridge chapter — its `\uses{}` graph is rooted in `RiemannRoch_WeilDivisor.tex` (landed iter-171). Without it, RR.3 ($\mathcal O_C(P)$ global sections) and RR.4 (rational curve ⟹ $\cong \mathbb P^1$) cannot proceed, and the final RR bridge `genusZero_curve_iso_P1` consumed by `AbelianVarietyRigidity.tex`'s `prop:genusZero_curve_iso_P1` stays blocked. Specialising to genus 0 sidesteps the general Serre-duality machinery (Mathlib has no dualizing sheaf), making this a viable short build (~3–5 iters per STRATEGY.md).

**Key declarations** (in dependency order):
1. `\definition` `\label{def:eulerChar_curve}` — Euler characteristic $\chi(\mathcal F) := \sum_i (-1)^i \dim_{\bar k} H^i(C, \mathcal F)$ of a coherent sheaf on a smooth proper curve over $\bar k$. `\lean{AlgebraicGeometry.Scheme.eulerCharacteristic}` [expected]. Source: Hartshorne IV §1 (formula 1.2.1).
2. `\definition` `\label{def:l_invariant}` — $\ell(D) := \dim_{\bar k} H^0(C, \mathcal O_C(D))$ for a Weil divisor $D$ on a smooth proper curve over $\bar k$. `\lean{AlgebraicGeometry.Scheme.WeilDivisor.l}` [expected]. Source: Hartshorne IV §1 (eq. (1.2)).
3. `\theorem` `\label{thm:euler_char_eq_deg_plus_one_minus_genus}` — On a smooth proper curve over $\bar k$, $\chi(\mathcal O_C(D)) = \deg(D) + 1 - g$. `\lean{AlgebraicGeometry.Scheme.eulerCharacteristic_eq_degree_plus_one_minus_genus}` [expected]. Source: Hartshorne IV Thm 1.3 (Riemann–Roch); genus-0 specialisation Hartshorne IV.1.3.5.
4. `\theorem` `\label{thm:riemannRoch_genus_zero}` — Genus-0 specialisation: on a smooth proper geometrically irreducible curve $C / \bar k$ with $g(C) = 0$ and $D \in \mathrm{Div}(C)$ with $\deg(D) \geq 0$, $\ell(D) = \deg(D) + 1$. `\lean{AlgebraicGeometry.Scheme.WeilDivisor.l_eq_degree_plus_one_of_genus_zero}` [expected]. Source: Hartshorne IV.1.3.5.

**`\uses` skeleton**:
- `def:eulerChar_curve` uses `def:genus` (from `Genus.tex`).
- `def:l_invariant` uses `def:codim1_cycles` (from `RiemannRoch_WeilDivisor.tex`), `def:eulerChar_curve`.
- `thm:euler_char_eq_deg_plus_one_minus_genus` uses `def:eulerChar_curve`, `def:divisor_degree` (from RR.1).
- `thm:riemannRoch_genus_zero` uses `thm:euler_char_eq_deg_plus_one_minus_genus`, `thm:principal_deg_zero` (RR.1).

**Main theorem proof strategy**: Riemann–Roch for genus 0 is the case where Serre duality collapses (the canonical divisor $K_C$ has $\deg K_C = -2 < 0$ on $\mathbb P^1$, so $\ell(K_C - D) = 0$ for $\deg D \geq 0$). Hartshorne IV Thm 1.3 derives the full RR via the additive sub-divisor $D \mapsto D + P$ inductive step on $\chi(\mathcal O_C(D)) - \deg(D)$; the genus-0 specialisation is one short corollary. The induction step requires the short exact sequence $0 \to \mathcal O_C(D) \to \mathcal O_C(D + P) \to \mathcal O_C(D + P)|_P \to 0$ and additivity of $\chi$ in short exact sequences (Mathlib: `CategoryTheory.ShortExact.eulerChar_additive` — present). The Serre-duality-free formulation avoids the Mathlib dualizing-sheaf gap.

**References for writer**:
- `references/hartshorne-algebraic-geometry.md` (`hartshorne-algebraic-geometry.pdf`), IV §1 pp. 294–296 — RR statement and proof outline; Example IV.1.3.5 the genus-0 special case.
- `references/stacks-coherent.md`, tag 0BSC (Riemann–Roch for curves) — Stacks formulation.
- `analogies/rrbridge-survey.md` (in-tree) — the project's existing RR-bridge survey.

**Subphase choices exposed**:
- **Serre duality vs. direct $\chi$**: prove RR (i) by routing through Serre duality $H^1(C, \mathcal F) \cong H^0(C, \omega_C \otimes \mathcal F^\vee)^*$ and computing both sides, or (ii) directly via the $\chi$ inductive proof above. Recommendation: **(ii) direct $\chi$** — Mathlib has no dualizing sheaf, and the inductive proof needs only short-exact-sequence additivity of $\chi$, a project asset already partially present in `Cohomology_*.tex`.
- **Genus-0 carve-out vs. general $g$**: include the general-genus theorem (heavier, ~6–8 iters) or restrict to the $g = 0$ specialisation (~3–5 iters). Recommendation: **restrict to $g = 0$**, matching STRATEGY.md row 2's intent; general genus is downstream of RR.2 and not needed for the genus-0 critical path.

## Per-chapter

### blueprint/src/chapters/AbelJacobi.tex — complete + correct, no notes.

### blueprint/src/chapters/AbelianVarietyRigidity.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - missing — three named scaffold sorries `gmScalingP1_chart`, `gmScalingP1_chart_agreement`, `gmScalingP1_over_coherence` referenced only in TeX NOTE comments (L1213–1219, L1276–1277), not in dedicated `\begin{lemma}…\lean{…}\end{lemma}` blocks. Confirms iter-172 `g0bo172`. **Hard-gates the `Genus0BaseObjects.lean` prover lane this iter** until the parallel `blueprint-writer g0bo-pin-scaffolds` dispatch lands the pins; iter-173 fast-path re-fire SHOULD be invoked once that writer returns.
  - sound — all 19 in-block declaration pins (rigidity-lemma chain L86–L617, Milne §I.3 chain L691–L1750) are correct mathematically; route-C exposition is internally consistent and matches `AbelianVarietyRigidity.lean`'s axiom-clean closure status from iter-162.
  - citation-discipline — all `% SOURCE: …` parentheticals name files that exist on disk (`abelian-varieties.pdf`, `hartshorne-algebraic-geometry.pdf`, `mumford-abelian-varieties.pdf`); the per-section iter-noting (`NOTE (iter-NNN): …`) is faithful to the per-iter audit history. No fabrication.

### blueprint/src/chapters/AlgebraicJacobian_Cotangent_GrpObj.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_MayerVietoris.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_SheafCompose.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_StructureSheafAb.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex — complete + correct, no notes.

### blueprint/src/chapters/Differentials.tex — complete + correct, no notes.

### blueprint/src/chapters/Genus.tex — complete + correct, no notes.

### blueprint/src/chapters/Jacobian.tex
- **complete**: partial
- **correct**: partial
- **notes**:
  - wrong (stale) — L344 says A.4 is "~900–1200 LOC, ~7–11 iters", contradicting STRATEGY.md ("~22–35 iters") and the iter-172 audit at the same chapter (L574–602 + L656). Confirms `jacobian172`.
  - wrong (stale) — L384–390 (A.4 paragraph in "Route A — per-sub-phase LOC and iter budget") says A.4 is "Char-free" and "Reuses the proven Rigidity Lemma + Cor 1.2 + Cor 1.5 from the genus-$0$ stack (already in tree, axiom-clean per iter-162)", omitting the Thm 3.2 / Lemma 3.3 / Auslander–Buchsbaum sub-build the iter-172 audit identified as load-bearing.
  - wrong (stale) — L425–427 in the Mathlib-prerequisite cascade says "(A.4) → no new Mathlib namespace; reuses AlgebraicJacobian.AbelianVarietyRigidity (in tree, axiom-clean) + Mathlib's Albanese-style universal property machinery", contradicting the iter-172 audit explicit statement "The STRATEGY.md A.4 row claim ‘no new Mathlib namespace’ is incorrect with respect to this Lemma 3.3 sub-build" (L656).
  - **HARD-GATE STATUS**: Jacobian.tex is **not feeding an active prover lane this iter** (the live lanes are G0BO, RelativeSpec, WeilDivisor). The `jacobian-a4-prose-fix` writer dispatch fixes this in parallel; no separate fast-path is needed for the planner to send this iter's lanes. Re-confirmed verdict next iter once the writer lands.

### blueprint/src/chapters/Picard_RelativeSpec.tex
- **complete**: true
- **correct**: true
- **notes**:
  - **HARD-GATE FOR `AlgebraicJacobian/Picard/RelativeSpec.lean` PROVER LANE: CLEARS.** All 5 declarations (`def:qc_sheaf_of_algebras`, `thm:relative_spec_exists`, `thm:relative_spec_univ`, `thm:relative_spec_affine_base`, `thm:relative_spec_base_change`, `thm:relative_spec_functorial`) carry well-formed `\lean{…}` pins; cross-refs internally consistent; proof sketches sufficiently detailed for a prover.
  - citation-discipline (informational, NOT blocking) — `thm:relative_spec_univ` L185–190's `% SOURCE QUOTE PROOF:` is the placeholder "TODO retrieve from references/stacks-constructions.tex (proof of lemma-spec, L553–600, ~50 lines …). Verbatim quote omitted for length". Since this block now feeds the iter-173 prover lane, a writer should retrieve and paste the verbatim proof body to satisfy citation discipline. Flag for `blueprint-writer relspec-proofquote-fill` follow-up (NOT a HARD-GATE blocker — the structural proof is well-described).
  - encoding note — `thm:relative_spec_univ` L137–183 phrases the universal property both as a representable functor (`F : Sch^op → Set`) and as the natural Hom-bijection $\Hom_X(T, \underline{\Spec}_X(\mathcal A)) \cong \Hom_{\mathcal O_X\text{-alg}}(\mathcal A, g_* \mathcal O_T)$. The Lean target name `AlgebraicGeometry.Scheme.RelativeSpec.UniversalProperty` is consistent with either packaging. Prover should choose `CategoryTheory.Functor.RepresentableBy` (chapter explicitly recommends it at L423–425).

### blueprint/src/chapters/RiemannRoch_WeilDivisor.tex
- **complete**: partial
- **correct**: partial
- **notes**:
  - missing — chapter does not name a Lean-side encoding for the `PrimeDivisor` predicate (the Lean file at L84–90 uses `point : X` + placeholder `isCodim1AndIntegral : True := trivial`). Chapter only flags this in a NOTE comment of `def:codim1_cycles` (L91–99); it should be lifted to a `% NOTE: encoding decision pending` paragraph in the prose body and pinned to a `\lean{AlgebraicGeometry.Scheme.PrimeDivisor}` block (currently no `\lean{…}` for `PrimeDivisor` exists in the chapter). Confirms iter-172 `wd172`.
  - missing — `def:divisor_degree`, `def:principal_divisor`, `def:divisor_closed_point` prose specifies the math hypothesis sets ("smooth proper curve over $\bar k$", "$(*)$") in textbook form but does not match these to the Lean signature shape (e.g. `[IsAlgClosed kbar]` + `[IsProper C.hom]` + `[SmoothOfRelativeDimension 1 C.hom]` etc.). Confirms iter-172 `wd172`.
  - wrong — `thm:divisor_degree_hom` L228–254 states the theorem with curve-over-$\bar k$ hypothesis in prose, but the Lean signature `degree_hom : X.WeilDivisor →+ ℤ` at L197 has NO `[IsAlgClosed]` instance and is stated for a general `{X : Scheme.{u}}`. Either the chapter needs to weaken its hypothesis to match (degree map is well-defined on any `X.WeilDivisor` once `PrimeDivisor` is encoded), or the Lean signature needs to add the curve hypotheses. Pre-repair: chapter must pick one — the `wd-spec-refine` writer dispatch resolves this.
  - **HARD-GATE STATUS**: `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean` body-fill lane (`degree_hom` + `PrimeDivisor` placeholder repair) is **HARD-GATED PRE-REPAIR**. Once `blueprint-writer wd-spec-refine` returns, iter-173 fast-path re-fire SHOULD verify the chapter has resolved (i) and (ii); planner then dispatches the prover lane.

### blueprint/src/chapters/Rigidity.tex — complete + correct, no notes.

### blueprint/src/chapters/RigidityKbar.tex — complete + correct, no notes.

## Cross-chapter notes

- `Jacobian.tex` § C.2.d (L484) cites `\cref{lem:rational_map_to_av_extends}` (Milne Thm 3.2) as part of the genus-0 route description, but `AbelianVarietyRigidity.tex` `rmk:thm32_codim1_mathlib_gap` (L874–906) explicitly states "This surface extension is *not* on the genus-0 critical path (corrected, iter-164)" — i.e. Theorem 3.2 is **Route-A-only**. The Jacobian.tex § C.2.d prose appears to predate the iter-164 demotion. Soft inconsistency: the prose says "the additive-defect map $\psi$… extended to the complete surface $\mathbb P^1 \times \mathbb P^1$ (rational-map extension `\cref{lem:rational_map_to_av_extends}`, Milne Thm 3.2/3.4)" but the project's committed route C.2.d (route (c), iter-164) bypasses this via the $\mathbb G_m$-scaling shortcut. Recommend a small prose edit on Jacobian.tex § C.2.d-(c) bullet (L484) to mention "primary route uses only Cor 1.5 + scaling fixed point; the historical $\mathbb G_a/\mathbb G_m$ incompatibility framing is retained as the demoted alternative" rather than describing the demoted alternative as the chain's structural backbone. This is a documentation-quality observation, not HARD-GATE-relevant.
- `AbelJacobi.tex` (L82) cites `\cref{thm:rigidity_over_kbar}` as the genus-0 keystone, but the project's iter-157+ committed keystone is `\cref{thm:rigidity_genus0_curve_to_AV}` (`AbelianVarietyRigidity.tex` L1696–1750). The reference to `thm:rigidity_over_kbar` is to the fallback-(a) artifact. Should be updated to also (or instead) cite the committed keystone. Soft.

## Severity summary

**must-fix-this-iter** (5):
- `AbelianVarietyRigidity.tex`: complete: partial — three missing `\lean{…}` pin blocks for `gmScalingP1_chart{,_agreement,_over_coherence}`. HARD-GATES `Genus0BaseObjects.lean` prover lane. Already covered by parallel-dispatched `blueprint-writer g0bo-pin-scaffolds`. Iter-173 fast-path re-fire required.
- `Jacobian.tex`: complete: partial / correct: partial — stale A.4 prose at L344, L384–390, L425–427. Does NOT hard-gate any active prover lane this iter, but the partial verdict triggers must-fix per blueprint-reviewer rules. Already covered by parallel-dispatched `blueprint-writer jacobian-a4-prose-fix`.
- `RiemannRoch_WeilDivisor.tex`: complete: partial / correct: partial — `PrimeDivisor` encoding + hypothesis-set mismatches. HARD-GATES `RiemannRoch/WeilDivisor.lean` body-fill lane. Already covered by parallel-dispatched `blueprint-writer wd-spec-refine`. Iter-173 fast-path re-fire required.
- **unstarted-phase proposal: Picard_LineBundlePullback** — dispatch `blueprint-writer` for `blueprint/src/chapters/Picard_LineBundlePullback.tex` or record deferral.
- **unstarted-phase proposal: Picard_FGA_FlatteningStratification** — dispatch `blueprint-writer` for `blueprint/src/chapters/Picard_FGA_FlatteningStratification.tex` or record deferral.
- **unstarted-phase proposal: RiemannRoch_RRFormula** — dispatch `blueprint-writer` for `blueprint/src/chapters/RiemannRoch_RRFormula.tex` or record deferral.

**soon** (2):
- `Picard_RelativeSpec.tex` / `thm:relative_spec_univ`: `% SOURCE QUOTE PROOF:` placeholder at L185–190 — retrieve and paste the verbatim Stacks lemma-spec proof body (~50 lines from `references/stacks-constructions.tex` L553–L600). Block feeds the iter-173 RelativeSpec prover lane; close the citation gap soon.
- Cross-chapter prose drift between `Jacobian.tex` § C.2.d-(c) and `AbelianVarietyRigidity.tex` `rmk:thm32_codim1_mathlib_gap` — the Jacobian.tex bullet still describes the demoted $\mathbb G_a$-additive route as the primary structural backbone; should be updated to lead with the $\mathbb G_m$-scaling shortcut.

**informational** (1):
- `AbelJacobi.tex` L82 cites the fallback `thm:rigidity_over_kbar` rather than the committed keystone `thm:rigidity_genus0_curve_to_AV`. Stale cross-reference; harmless but worth a one-line patch.

**Overall verdict.** HARD GATE for iter-173 prover dispatch: (i) `Picard/RelativeSpec.lean` lane CLEARS on `Picard_RelativeSpec.tex` (complete + correct + no must-fix touching it); planner MAY dispatch the prover this iter as planned. (ii) `Genus0BaseObjects.lean` and `RiemannRoch/WeilDivisor.lean` lanes are HARD-GATE-BLOCKED PRE-REPAIR — defer those prover dispatches UNTIL the parallel-dispatched `blueprint-writer g0bo-pin-scaffolds` and `blueprint-writer wd-spec-refine` return, then invoke the iter-173 fast-path scoped re-review on the two chapters. Three unstarted-phase chapters proposed for immediate writer dispatch (Picard_LineBundlePullback, Picard_FGA_FlatteningStratification, RiemannRoch_RRFormula); together these unblock A.1.c / A.2.b / RR.3 next iter and prevent a parallelism deficit. The 13-chapter blueprint state is otherwise healthy and route coverage is sound.
