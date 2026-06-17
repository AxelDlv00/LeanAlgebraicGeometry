# Blueprint Writer Report

## Slug
rrformula

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/RiemannRoch_RRFormula.tex (NEW)

## Changes Made
- **Created the chapter** `blueprint/src/chapters/RiemannRoch_RRFormula.tex` with the iter-173 directive header `% archon:covers AlgebraicJacobian/RiemannRoch/RRFormula.lean`, a chapter `\label{chap:RiemannRoch_RRFormula}`, standing-hypotheses paragraph, and the four directive declarations + their proof sketches. No `\leanok` / `\mathlibok` markers (per descriptor + directive).
- **Added definition** `\definition` / `\label{def:eulerChar_curve}` / `\lean{AlgebraicGeometry.Scheme.eulerCharacteristic}` — Euler characteristic of a coherent sheaf on a curve (two-term form $\chi = \dim H^0 - \dim H^1$ via Grothendieck vanishing on a $1$-dimensional scheme), with Hartshorne IV.1 (proof of Thm 1.3, p.~295) verbatim quote and Lean-signature paragraph pinning the $\Module\bar k$-flavoured-sheaf-cohomology + `Module.finrank` pipeline.
- **Added definition** `\definition` / `\label{def:l_invariant}` / `\lean{AlgebraicGeometry.Scheme.WeilDivisor.l}` — $\ell(D) := \dim_{\bar k} H^0(C, \mathcal O_C(D))$ with Hartshorne IV.1, p.~295 verbatim quote of the $l(D)$ definition and the project's $\Module\bar k$-cohomology pipeline pinned.
- **Added theorem** `\theorem` / `\label{thm:euler_char_eq_deg_plus_one_minus_genus}` / `\lean{AlgebraicGeometry.Scheme.eulerCharacteristic_eq_degree_plus_one_minus_genus}` — $\chi(\mathcal O_C(D)) = \deg(D) + 1 - g$; statement and proof sketch (Hartshorne IV Thm 1.3 + verbatim proof body for the inductive step) included; proof sketch shape = base case $D=0$ via genus def + $H^0(\mathcal O_C) = \bar k$, inductive step via SES $0\to\mathcal O_C(-[P])\to\mathcal O_C\to k(P)\to 0$ tensored by $\mathcal O_C(D+[P])$, additivity of $\chi$ on SES, and $\chi(k(P))=1$. Lean-reference note flags the missing `CategoryTheory.ShortExact.eulerChar_additive` and pins the additivity assumption as [expected].
- **Added theorem** `\theorem` / `\label{thm:riemannRoch_genus_zero}` / `\lean{AlgebraicGeometry.Scheme.WeilDivisor.l_eq_degree_plus_one_of_genus_zero}` — $\ell(D) = \deg(D) + 1$ for $g(C) = 0$ and $\deg(D) \geq 0$; statement uses Hartshorne IV.1.3.5 (p.~297) verbatim quote; proof unfolds $\chi = \dim H^0 - \dim H^1$ via Thm 3 at $g = 0$ and consumes the $H^1$-vanishing input (queued as a named premise the iteration that closes RR.3 will discharge).
- **Added `% NOTE:`** for the Serre-duality-vs-direct-$\chi$ choice (iter-173 sub-phase choice 1 — direct $\chi$ inductive proof, with the Mathlib-side reason).
- **Added `% NOTE:`** for the genus-$0$-carve-out-vs-general-$g$ choice (iter-173 sub-phase choice 2 — $\ell(D) = \deg(D)+1$ restricted to $g = 0$, with the $\chi$ intermediate stated for general $g$).
- **Added `\section{Out of scope}`** listing four explicit out-of-scope items (general-$g$ Riemann–Roch via Serre duality, the $\mathcal O_C(D)$ construction + linear-equivalence isomorphism + $H^0(\mathcal O_C([P])) = 2$ deferred to RR.3, the genus-$0$ $H^1$ vanishing premise discharge deferred to RR.3, and the rational-curve $\cong \mathbb P^1$ classification deferred to RR.4).

## Cross-references introduced
- `\uses{def:genus}` — verify `def:genus` exists in `Genus.tex` (it does, L17).
- `\uses{def:codim1_cycles}`, `\uses{def:divisor_degree}`, `\uses{thm:divisor_degree_hom}`, `\uses{def:divisor_closed_point}`, `\uses{thm:principal_deg_zero}` — verify all exist in `RiemannRoch_WeilDivisor.tex` (they do: L218, L347, L391, L302, L497).
- `\uses{def:Scheme_HModule}` — referenced in the Lean-signature note of `def:eulerChar_curve` for the $\Module \bar k$-flavoured cohomology wrapper; verify exists in `Cohomology_StructureSheafModuleK.tex` (the chapter `Genus.tex` L20 already cites `def:Scheme_HModule` and `def:Scheme_toModuleKSheaf` — both should be present in the sibling cohomology chapter).
- `\cref{prop:genusZero_curve_iso_P1}` referenced in the chapter intro and in the closing sub-build note — this lives in `AbelianVarietyRigidity.tex` L1793 (verified).
- `\Cref{def:eulerChar_curve}`, `\Cref{def:l_invariant}`, `\Cref{thm:euler_char_eq_deg_plus_one_minus_genus}`, `\Cref{thm:riemannRoch_genus_zero}` — internal references within the chapter (all present).

## References consulted
- `references/summary.md` — index, identified `references/hartshorne-algebraic-geometry.md` + PDF as the source for IV §1 pp.~294–297.
- `references/hartshorne-algebraic-geometry.md` — reference card; confirmed PDF page offset (doc p.294 → PDF p.311; doc p.295 → PDF p.312; doc p.296 → PDF p.313; doc p.297 → PDF p.314), and the genus / RR / IV.1.3.5 map.
- `references/hartshorne-algebraic-geometry.pdf` — rendered PDF pages 311 / 312 / 313 / 314 to PNG via `pdftoppm -r 200` (the PDF is scanned-image only and has no text layer; the project's reference card warns of this). Read all four images and transcribed the verbatim quotes character-by-character. The four `% SOURCE QUOTE` blocks and the one `% SOURCE QUOTE PROOF` block were produced from these page images. Specifically:
  - Page 295 (PDF 312): definition of $\chi(\mathscr F) = \dim H^0(X, \mathscr F) - \dim H^1(X, \mathscr F)$ inside the proof of Theorem 1.3; definition $l(D) := \dim_k H^0(X, \mathscr L(D))$; statement of Theorem 1.3 (Riemann–Roch).
  - Page 295–296 (PDF 312–313): proof of Theorem 1.3 — base case $D = 0$, inductive SES $0 \to \mathscr L(-P) \to \mathscr O_X \to k(P) \to 0$ tensored by $\mathscr L(D + P)$, additivity of $\chi$, $\chi(k(P)) = 1$.
  - Page 297 (PDF 314): Example 1.3.5 verbatim.
- `blueprint/src/chapters/RiemannRoch_WeilDivisor.tex` — sibling RR.1 chapter, to verify cross-reference labels and consistent prose style.
- `blueprint/src/chapters/Genus.tex` — confirmed `def:genus` exists and reflects $g(C) = \dim_k H^1(C, \mathcal O_C)$.
- `blueprint/src/chapters/AbelianVarietyRigidity.tex` (L1793–1900 area) — confirmed downstream consumer `prop:genusZero_curve_iso_P1`.
- `.lake/packages/mathlib/Mathlib/Algebra/Homology/EulerCharacteristic.lean` (Mathlib snapshot `b80f227`) — verified the available Euler-characteristic API (`HomologicalComplex.eulerChar`, `GradedObject.eulerChar`, `eulerChar_eq_sum_finSet_of_finrankSupport_subset`) and the absence of `CategoryTheory.ShortExact.eulerChar_additive` under that exact name.
- `references/hartshorne-algebraic-geometry.md` reference card already enumerates Hartshorne IV §1 contents; no reference-retriever dispatch was needed.

## Macros needed (if any)
- None: all LaTeX commands used (`\Div`, `\codim`, `\Cl`, `\Pic`, `\cref`, `\Cref`, `\struct`, `\Module`, `\ULift`, `\Spec`, `\HModule`, `\toModuleKSheaf`, `\Linear`, `\Sheaf`, `\Hom`, `\Ext`, `\Scheme`) are already in use across sibling chapters `RiemannRoch_WeilDivisor.tex` and `Genus.tex`, so they are defined (or `\providecommand`-stubbed) in `macros/common.tex`.

## Reference-retriever dispatches (if any)
- None. The verbatim text required from `references/hartshorne-algebraic-geometry.pdf` IV §1 pp.~294–297 was extractable directly by rendering pages 311–314 to PNG via `pdftoppm` and reading them through the multimodal `Read` tool. No external retrieval was needed.

## Mathlib name verification (per directive's "Verification step")
- `CategoryTheory.ShortExact.eulerChar_additive` — **NOT present** in Mathlib snapshot `b80f227` under that exact name. The closest available API in `Mathlib.Algebra.Homology.EulerCharacteristic` defines `HomologicalComplex.eulerChar` (abbrev), `GradedObject.eulerChar` (`noncomputable def`), and the rewriting lemma `HomologicalComplex.eulerChar_eq_sum_finSet_of_finrankSupport_subset`, but ships **no** specific additivity-on-short-exact-sequences theorem with the proposed name. Tagged **[expected]** in the chapter's Lean-reference note for the proof of `thm:euler_char_eq_deg_plus_one_minus_genus`; the chapter explicitly notes that the prover either threads the additivity as a project-side lemma (via `Submodule.finrank_quotient_add_finrank` + long exact sequence) or contributes a Mathlib upstream PR.

## Verification step (per directive)
- **4 `\lean{...}` pins**: ✓
  - `AlgebraicGeometry.Scheme.eulerCharacteristic` (for `def:eulerChar_curve`)
  - `AlgebraicGeometry.Scheme.WeilDivisor.l` (for `def:l_invariant`)
  - `AlgebraicGeometry.Scheme.eulerCharacteristic_eq_degree_plus_one_minus_genus` (for `thm:euler_char_eq_deg_plus_one_minus_genus`)
  - `AlgebraicGeometry.Scheme.WeilDivisor.l_eq_degree_plus_one_of_genus_zero` (for `thm:riemannRoch_genus_zero`)
- **4 `% SOURCE:` + verbatim `% SOURCE QUOTE:` blocks (with a 5th `% SOURCE QUOTE PROOF:` for Thm 3)**: ✓ — each `% SOURCE QUOTE` / `% SOURCE QUOTE PROOF` was transcribed character-by-character from a PNG render of the cited page of `references/hartshorne-algebraic-geometry.pdf`.
- **`\uses{...}` graph roots**: ✓ — `def:genus` (Genus.tex), `def:codim1_cycles` + `def:divisor_degree` + `def:divisor_closed_point` + `thm:divisor_degree_hom` + `thm:principal_deg_zero` (RR.1, RiemannRoch_WeilDivisor.tex) are all referenced. The chapter's intra-uses chain definitions ⊃ chi-identity ⊃ genus-0 RR is internally consistent.
- **Mathlib additivity name labeled**: ✓ — `CategoryTheory.ShortExact.eulerChar_additive [expected]` tag is in the Lean-reference note inside the proof of `thm:euler_char_eq_deg_plus_one_minus_genus`.
- **`% archon:covers AlgebraicJacobian/RiemannRoch/RRFormula.lean` header**: ✓
- **No `\leanok` / `\mathlibok` markers**: ✓ (`grep -c '\\leanok\|\\mathlibok'` returned `0`).
- **LaTeX env balance**: 6 `\begin{...}` blocks (4 declarations + 2 proofs) balance 6 `\end{...}` blocks. No dangling environments.
- **Scope restriction**: ✓ — the chapter does NOT define $\mathcal O_C(D)$ as a line bundle (deferred to RR.3); does NOT prove genus-0 ⟹ ℙ¹ (deferred to RR.4); does NOT instantiate the general-$g$ RR with Serre duality (out-of-scope).

## Notes for Plan Agent
- The genus-$0$ $H^1$-vanishing $H^1(C, \mathcal O_C(D)) = 0$ for $\deg(D) \geq 0$ is consumed by `thm:riemannRoch_genus_zero` as a named premise in the Lean signature. RR.3 is the natural home for its closure (via the explicit cohomology of $\mathcal O_{\mathbb P^1}(d)$ once `genusZero_curve_iso_P1` is closed, OR by direct projective-line-base-change). The plan agent should consider scheduling the RR.3 chapter (`RiemannRoch_OcOfD.tex`) alongside or after the RR.2 prover lane so that the premise is discharged in the same iter.
- The additivity-of-$\chi$-on-SES name `CategoryTheory.ShortExact.eulerChar_additive` is **not present** in Mathlib. The prover lane for `eulerCharacteristic_eq_degree_plus_one_minus_genus` will need either (a) a project-side helper proved from `Submodule.finrank_quotient_add_finrank` + the long exact sequence of $H^0/H^1$ on a SES of coherent sheaves on a 1-dimensional proper $\bar k$-scheme, or (b) a Mathlib upstream PR contributing the categorical-Euler-characteristic additivity. The chapter prose flags this as a candidate Mathlib upstream contribution.
- A small cross-chapter consistency check: `Genus.tex` L42–48 lists $g(C) = 1 - \chi(\mathcal O_C)$ as a Riemann–Roch consequence "available once Riemann–Roch and Serre duality are formalised". With `thm:euler_char_eq_deg_plus_one_minus_genus` of this chapter, the $D = 0$ specialisation directly yields $\chi(\mathcal O_C) = 1 - g$, i.e. $g = 1 - \chi(\mathcal O_C)$, with NO Serre duality involved. After this chapter lands, `Genus.tex`'s comment may be updated to reflect that the $1 - \chi$ identity is now closed (informational; out of this writer's write-domain).

## Strategy-modifying findings
None. The chapter's content (statement, proof sketch, hypothesis surface, scope) matches the iter-173 directive and the iter-173 `blueprint-reviewer route173` proposal; no strategy-level adaptation was needed to write it.
