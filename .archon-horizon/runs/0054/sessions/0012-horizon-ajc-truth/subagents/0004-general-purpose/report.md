I have everything needed. Here are my findings.

## A) `\leanok` honesty — the four touched nodes

**The convention this blueprint uses** (established by the closest structural analogue, not by guesswork):

`thm:pic0_isAbelianVariety` at `blueprint/src/chapters/Picard_Pic0AbelianVariety.tex:1405` carries `\leanok` on the *statement* but its `proof` at line 1449 has **no `\leanok`**. Its Lean, `Scheme.Pic0.isAbelianVariety` (`AlgebraicJacobian/Picard/Pic0AbelianVariety.lean:874-881`), is `⟨proper C, smooth C, geometricallyIrreducible C, grpObj C⟩` — exactly the same situation as the witnesses: **no `sorry` in its own body, but two of its four arguments (`Pic0.smooth:800`, `Pic0.proper:820`) are `sorry`**. So the house convention here is: *sorry-dependent-but-locally-complete ⇒ statement may carry `\leanok`, the proof must not.* The sorry-bodied leaves themselves (`thm:pic0_smooth:1095`, `thm:pic0_proper:1211`) carry `\leanok` on **neither**.

Against that convention, the four touched nodes are **all consistent and honest**:

| node | line | statement `\leanok` | proof `\leanok` | verdict |
|---|---|---|---|---|
| `def:picardJacobianWitnessOfHasRationalPoint` | Jacobian.tex:114 | no | no (:125) | fine — conservative, strictly stricter than the `pic0_isAbelianVariety` precedent |
| `rem:pointed_witness_scope` | :158 | no | n/a | fine |
| `def:picardJacobianWitness` | :181 | no | no (:191) | fine |
| `def:picardJacobianWitnessOfIsAlgClosed` | :333 | no | no (:343) | fine |

Nothing claims `\leanok` it has not earned. The agent in fact *under*-claimed relative to precedent — it could have put `\leanok` on the three statements (the Lean signatures exist and match) and been consistent. That is a defensible tightening, not a defect, and it matches how the same file already handles the sorry-carrying `def:picardJacobianWitness` before the refactor (also no `\leanok`).

**Note on one genuine internal inconsistency, pre-existing not introduced:** `lem:pic0_isAlbanese_algClosed`'s proof at `Jacobian.tex:447` carries `\begin{proof}\leanok` while its statement (line 435) does not. Its Lean `isAlbanese_pic0_of_isAlgClosed` (`Jacobian.lean:473-484`) has no `sorry` of its own but its docstring at :471 states outright "`Pic0.abelJacobi` is `sorry`-bodied, so this theorem's own axioms carry `sorryAx` and it is not a discharge of anything." That `\leanok` on the proof of a sorry-dependent node contradicts the `pic0_isAbelianVariety` convention. Same pattern at `lem:pic0_tangent_dimension_genus` (`Jacobian.tex:375/386`), whose Lean docstring at `Jacobian.lean:396` similarly says "its axioms carry `sorryAx`". Both predate this commit (not in the fd9789da3 diff), so they are not this agent's doing, but they mean the file is not self-consistent and someone reading it to infer the convention could land on either answer.

**`\lean{...}` name verification — all four exist:**
- `AlgebraicGeometry.picardJacobianWitnessOfHasRationalPoint` → `AlgebraicJacobian/Jacobian.lean:509`
- `AlgebraicGeometry.picardJacobianWitness` → `Jacobian.lean:554`
- `AlgebraicGeometry.picardJacobianWitnessOfIsAlgClosed` → `Jacobian.lean:592`
- and the statements match the blueprint text: the new node's `[Scheme.HasRationalPoint C]` binder (`Jacobian.lean:511`) is exactly the "possessing a `k`-rational point" hypothesis at `Jacobian.tex:120-122`; the two specialisations' two-line `haveI := ...; picardJacobianWitnessOfHasRationalPoint C` bodies (`:557-558`, `:595-596`) are exactly the "Apply … with the point supplied by …" proofs.

## B) Is the new node's proof complete, and was content deleted?

**The seven-step assembly is genuinely written out at `Jacobian.tex:125-156`**, not sketched or pointed at. It names the four fields from `thm:pic0_isAbelianVariety` (group scheme, smooth, proper, geometrically irreducible), then the three isolated extensions with the actual mathematical reason each is needed: integrality-vs-irreducibility reconciliation, the tangent-space identification `T_0 Pic⁰ ≅ H¹(C,𝒪_C)` supplying the relative dimension, and the extension of the Albanese property from (alg. closed, `g>0`) to (all `k`, all genus). That is a real argument. Cross-checked against the Lean: seven `where`-fields at `Jacobian.lean:513-519` — `J, grpObj, proper, smooth, geomIrred, smoothGenus, isAlbaneseFor` — so "seven data" is accurate.

**No content was deleted.** Comparing against fd9789da3: the seven-step body moved verbatim from `def:picardJacobianWitness` to the new node (the diff is pure relabelling plus the `def:inst_has_pic_scheme` insertion). The one paragraph that shrank — the old "the rational point is not, and is the single genuine gap … over an algebraically closed field it is `lem:curve_rational_point_algClosed` and the witness is `def:picardJacobianWitnessOfIsAlgClosed`" at old lines 160-166 — was **relocated intact** to the new `def:picardJacobianWitness` proof at `Jacobian.tex:194-198`, which is where it now belongs. Nothing was dropped.

**Do the two-line specialisation proofs stand alone?** Yes, marginally but sufficiently. `def:picardJacobianWitness`'s proof (`:191-199`) says what is applied, where the hypothesis comes from, that it is the single genuine gap, and that it is a gap only over general `k`. `def:picardJacobianWitnessOfIsAlgClosed`'s (`:343-355`) does the same and additionally enumerates all five remaining obligations. Under the house rule "the way to keep a proof short is to split, not to abbreviate", this is exactly the sanctioned pattern: the mathematics lives in the `\uses`-linked parent node.

## C) `\uses` correctness

All 20 distinct labels referenced by the four nodes resolve to real `\label`s — no danglers. Specifically `def:has_rational_point` → `Picard_FGAPicRepresentability.tex:815`, `def:inst_has_pic_scheme` → `:980`, `thm:fga_pic_representability` → `:230`, `thm:pic0_isAbelianVariety` → `Picard_Pic0AbelianVariety.tex:1406`, `thm:pic_zero_dimension_equals_genus` → `Picard_IdentityComponent.tex:1085`, `def:genus` → `Genus.tex:15`.

The new node's `\uses` correctly covers what the argument consumes: the representability gate (`def:inst_has_pic_scheme`, in the proof at `:126` — correctly moved there from the statement, since the gate is a proof dependency), Pic0 smooth/proper (via `thm:pic0_isAbelianVariety` in the statement at `:117`), the genus leaf (`lem:pic0_relative_dimension_genus`, `:127`), the Albanese leaf (`lem:pic0_isAlbanese_all_points`, `:127`), and `def:has_rational_point` for the new binder (`:118`). Both specialisations `\uses` the new node from their proofs (`:192`, `:344`). Statement-vs-proof placement follows the house rule throughout.

Two things worth noting, both minor:

1. `def:picardJacobianWitnessOfIsAlgClosed`'s statement still `\uses{def:picardJacobianWitness}` at `Jacobian.tex:336`. That edge is now stale in substance: the Lean no longer routes through `picardJacobianWitness` at all (`Jacobian.lean:595-596` goes straight to `picardJacobianWitnessOfHasRationalPoint`), and the agent added the correct edge to the proof at `:344` without removing the superseded statement edge. Harmless for the DAG (both witnesses exist) but it misdescribes the dependency.

2. `def:picardJacobianWitness` and `def:picardJacobianWitnessOfHasRationalPoint` both still carry `thm:fga_pic_representability` in their statement `\uses` (`:183`, `:116`), whereas the Lean chain actually consumes `Scheme.instHasPicScheme` (`FGAPicRepresentability.lean:259-263`, the `sorry` at :263) — `PicScheme.representable` (`:576-581`) is a separate extraction. The blueprint's own `rem:representability_is_conditional` (`Picard_FGAPicRepresentability.tex:~1000`) draws exactly this distinction. Pre-existing, not introduced by this commit.

## D) The abandoned Quot route

Reader-visible Quot material is **consistently framed as retained mathematics, not as the current route.** I checked every reader-visible occurrence; the route-decision prose is explicit and in the right places:

- `Picard_FGAPicRepresentability.tex:20-54` — the "Two routes to representability" section. States plainly at `:51-54`: "The Lean development therefore pursues the Milne--Koll\'ar route. The quotient-route material below is retained as the mathematics it is … and is not the path currently being formalised." **Correct framing.**
- `Picard_QuotScheme.tex:4484-4493` — "In Grothendieck's quotient route … the route set beside the Milne--Koll\'ar one in `sec:fga_pic_setup`, and not the one the formalisation follows … The functor is a piece of mathematics in its own right." **Reusable-mathematics framing. Do not flag.**
- `Picard_QuotScheme.tex:8416-8419` — "the engine of the quotient route to the Picard scheme, which `sec:fga_pic_setup` sets beside the Milne--Koll\'ar route the formalisation follows. The substrate … is consumed by either route." **Correct.**
- `Picard_FlatteningStratification.tex:2744-2747` — "the quotient route of `sec:fga_pic_setup`, a separate argument resting on a descent step the formalisation instead avoids by the Milne--Koll\'ar route." **Correct.**
- `Picard_FGAPicRepresentability.tex:1109` and `:1118` — "Along the Milne--Koll\'ar route … the one being formalised"; "No Hilbert or Quot scheme occurs among them." **Correct.**
- `Picard_FGAPicRepresentability.tex:397-411` (`rem:smooth_proper_quotient_hypothesis`) — explains why the quotient route's descent step is the obstruction. **Correct.**
- `Picard_QuotScheme.tex:1-3` — the chapter *title* is bare "The Quot scheme" and lines 5-30 (the STRATEGY NOTE carrying "That route is not the one being formalised") are all `%` **comments, hence not reader-visible**. The first reader-visible prose is `:35-50`, which describes the Quot construction neutrally as mathematics with no route claim. Not misleading, but the disclaimer a reader would want is precisely the part they cannot see. Same for the chapter's position in `content.tex:28` — chapter ordering places Quot before FGA, which reads as pipeline order; that is a presentational matter, not a false claim.
- `README.md:10-18` — explicitly names the Milne–Kollár route as committed and says the Quot route "is **not** the path being built". **Correct.**

**One genuine defect found in D**, and it is the only reader-visible place where Quot material reads as the current route:

`blueprint/src/chapters/RiemannRoch_Adelic.tex:2122`, inside the statement body of `thm:adelic_h1_vanishing`:

> "This is the curve-level replacement for Castelnuovo--Mumford boundedness in **the Quot endgame**."

Reader-visible (not a comment), definite article, present tense, and it appears inside a `corollary` statement rather than in route-discussion prose. It presents the Quot endgame as the live target this Riemann–Roch corollary feeds. It is also the sole occurrence of "endgame" anywhere in the blueprint, so nothing nearby corrects it. It additionally breaches the house "timeless mathematics, no project history" rule: a statement of `H¹` vanishing for `deg D > 2g-2` should not be justifying itself by which formalisation route consumes it.

Everything else in D is acceptable and should not be flagged.

## Summary

- **A:** No dishonest `\leanok`. All four touched nodes correctly omit it on both statement and proof; all four `\lean{...}` names exist and match. The relevant convention is set by `thm:pic0_isAbelianVariety` (statement `\leanok`, proof not) and the four are consistent with it, if slightly conservative. Pre-existing inconsistency at `Jacobian.tex:447` and `:386`, where sorry-dependent proofs do carry `\leanok` against that convention — not introduced here, but it makes the file ambiguous about its own rule.
- **B:** New node's proof is complete real mathematics, "seven data" matches the seven Lean fields, nothing was deleted — the one shrunken paragraph was relocated to `Jacobian.tex:194-198`.
- **C:** No dangling `\uses`, correct statement/proof placement, both specialisations link the new node. Stale-in-substance `def:picardJacobianWitness` edge at `Jacobian.tex:336` should be dropped now that the Lean bypasses it.
- **D:** One reader-visible defect: `RiemannRoch_Adelic.tex:2122` reads the Quot endgame as current. All other Quot material is correctly framed as retained mathematics.
