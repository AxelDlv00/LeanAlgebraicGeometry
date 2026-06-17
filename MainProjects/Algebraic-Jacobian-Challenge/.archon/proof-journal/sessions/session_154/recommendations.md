# Recommendations for the next plan iteration (post iter-154)

## Headline: KDM is CLOSED axiom-clean — the chart-algebra critical path is unblocked

`KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero` (the lemma blocked
iters 149–153) and its downstream delegate
`df_zero_factors_through_constant_on_chart` are both verified `sorryAx`-free.
`ChartAlgebra.lean` is now 0-sorry. Global sorry count 8 → 7.

## Closest-to-completion / next critical-path target

1. **`rigidity_over_kbar` (`RigidityKbar.lean:88`, M2.a keystone).** Per the
   prover task result and the auditor, this was gated on the cotangent-vanishing
   pile, of which the chart-algebra KDM piece was the live blocker. With KDM
   closed, re-assess `rigidity_over_kbar` as the next prover lane — but FIRST
   run the blueprint-reviewer HARD GATE on its chapter and have the plan agent
   confirm exactly which sub-pieces remain open (the M2.a keystone may still
   depend on other scaffolding; do not assume KDM closure alone discharges it).

## Strongly recommended cleanup (drops 4 sorries off the books)

2. **Delete `Cotangent/ChartAlgebraS3.lean` + drop its import at
   `ChartAlgebra.lean:6`.** Both review subagents + the auditor confirm this file
   is **fully orphaned**: imported only by `ChartAlgebra.lean`, which consumes
   NONE of its declarations (the alg-closed pivot removed the consumer). It
   carries **4 live sorries** (L180/199, L243/276, L324/342, L389/403) plus stale
   docstrings (L59–63) asserting live consumption that no longer exists. Deleting
   it would drop the **global sorry count 7 → 3**. This is a `refactor`-subagent
   task (structural deletion + import drop + coordinated blueprint handling of
   `AlgebraicJacobian_Cotangent_ChartAlgebraS3.tex`, which becomes orphaned —
   run blueprint-doctor after). Net simplification, not accretion. NOTE: this is
   a deletion of sorry-bodied descoped scaffolding — exactly the iter-145-discipline
   "in-tree excise is the disciplined response" pattern; git history preserves the
   bodies.

## Blueprint / comment hygiene (review agent already did the `% NOTE` fixes)

3. **`GrpObj.lean` stale comments (auditor major).** `shearMulRight` (L345–348)
   is falsely tagged `NEEDS_MATHLIB_GAP_FILL` though fully proven; the piece-(i.b)
   headers (L297–327, L428–451) narrate iter-145-excised lemmas
   (`relativeDifferentialsPresheaf_basechange_along_proj_two`,
   `mulRight_globalises_cotangent`) as live pending sorries, contradicted by the
   same file's L552–560 / L624–629 excise notes. A prover/refactor pass owning
   `GrpObj.lean` should strip these. Also check whether the support decls
   `schemeHomRingCompatibility` (L424), `section_snd_eq_identity_struct` (L458),
   `isIso_of_app_iso_module` (L544),
   `relativeDifferentialsPresheaf_restrict_along_identity_section` (L579) are now
   orphaned after the iter-145 main-lemma excision (consumer check).

4. **`RigidityKbar.tex` statement-block `\uses` at L2340 (checker minor; plan
   already deferred this).** The KDM statement-block `\uses` still over-declares
   `lem:chart_algebra_isPushout_of_affine_product` +
   `lem:KaehlerDifferential_constants_in_chart_of_proper_curve` even though the
   proof-block `\uses` was pruned (the live FT route is a self-contained Mathlib
   assembly). Not broken (both labels resolve, doctor clean), but the depgraph is
   inaccurate. Batch with the `constants_in_chart` helper demotion in a
   blueprint-writer round — this is the SOON item the iter-153/154 plans deferred.

5. **`ChartAlgebra.lean` minor hygiene (auditor minor; non-blocking).** `_hRev`
   (L207) computed-but-unused (honestly labelled); unused `{n}` /
   `[IsStandardSmoothOfRelativeDimension n k B]` binders (L200) — the docstring
   calls them "frozen" but the decl is NOT in `archon-protected.yaml` (loose
   wording, harmless). `Jacobian.lean:275` exceeds 100-char line limit.

## Do NOT retry / blockers retired

- **KDM / FT.3 is NO LONGER a blocker.** The iter-153 "genuine Mathlib gap /
  bright-line STOP" Known-Blocker entries are superseded — KDM is closed
  axiom-clean. Do not re-open the bright-line; do not re-dispatch an analogist on
  FT.3. (PROJECT_STATUS.md Known Blockers updated this review.)
- **Remaining authorized scaffold sorries** (NOT to be re-assigned blindly):
  `genusZeroWitness` / `positiveGenusWitness` (`Jacobian.lean:197/223`, Phase-C
  M2/M3 gates) and `rigidity_over_kbar` (`RigidityKbar.lean:88`, M2.a). These are
  long-standing, documented, load-bearing for the protected `Jacobian` — work them
  via their documented gates, not ad-hoc.

## Reusable proof pattern discovered (added to Knowledge Base)

- **Kernel-of-universal-Kähler-derivation = field of constants via the
  single-element / perfect-field / Jacobi–Zariski `H1Cotangent` route.** See the
  new PROJECT_STATUS.md Proof Pattern entry. The decisive move: stop describing
  `ker d` directly; realize cotangent base-change injectivity via
  `Algebra.H1Cotangent.exact_δ_mapBaseChange` + `FormallySmooth.of_perfectField`
  (char-0 ⟹ perfect base) + faithful flatness. Reusable for any "`D x = 0` ⟹ `x`
  algebraic over the base" obligation on a finitely-generated char-0 field
  extension.
