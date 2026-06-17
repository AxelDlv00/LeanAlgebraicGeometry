# Blueprint Writer Report

## Slug
rr3-ocp

## Status
COMPLETE

## Target chapter
`blueprint/src/chapters/RiemannRoch_OCofP.tex` (created)

## Changes Made

- **Added chapter scaffold** with `% archon:covers AlgebraicJacobian/RiemannRoch/OCofP.lean` pin and `\chapter{The line bundle $\mathcal O_C(P)$ and its global sections (RR.3)}` / `\label{chap:RiemannRoch_OCofP}`.
- **Added definition** `def:lineBundleAtClosedPoint` / `\lean{AlgebraicGeometry.Scheme.lineBundleAtClosedPoint}` — the invertible sheaf $\mathcal O_C(P)$ for a closed point $P$ on a smooth curve, with the Hartshorne~II.6 subsheaf-of-$\mathcal K_C$ description, dual-of-ideal-sheaf equivalent, and Lean signature scope.
- **Added lemma** `lem:lineBundleAtClosedPoint_globalSections_iff` / `\lean{...globalSections_iff}` — $H^0(C, \mathcal O_C(P)) \cong L([P])$ as the Riemann-Roch space of rational functions $f$ with $\ord_Q(f) \geq 0$ for $Q \neq P$ and $\ord_P(f) \geq -1$.
  - Proof sketch added: subsheaf-of-$\mathcal K_C$ description ⇒ stalk-by-stalk germ conditions ⇒ divisorial-language reformulation, matched against Hartshorne~II.7.7(b).
- **Added lemma** `lem:H1_vanishing_lineBundleAtClosedPoint_genusZero` / `\lean{...h1_vanishing_genusZero}` — the genus-0 cohomological vanishing $H^1(C, \mathcal O_C(P)) = 0$.
  - Proof sketch added: LES from SES $0 \to \mathcal O_C \to \mathcal O_C(P) \to k(P) \to 0$, plus $H^1(\mathcal O_C) = 0$ (genus-0 hypothesis) and $H^1(k(P)) = 0$ (skyscraper / flasque).
- **Added theorem** `thm:lineBundleAtClosedPoint_dim_eq_two_of_genusZero` / `\lean{...dim_eq_two_of_genusZero}` — $\dim_{\bar k} H^0(C, \mathcal O_C(P)) = 2$ on a genus-0 curve.
  - Proof sketch added: $\chi = \deg + 1 - g = 2$ via RR.2's `thm:euler_char_eq_deg_plus_one_minus_genus`, combined with the H¹-vanishing lemma. An alternative "all in one LES" route is recorded as a sidebar.
- **Added corollary** `cor:lineBundleAtClosedPoint_exists_nonconstant_genusZero` / `\lean{...exists_nonconstant_genusZero}` — existence of a non-constant $f \in K(C)$ with at most a simple pole at $P$ and no other poles, plus that $(1, f)$ spans $H^0(C, \mathcal O_C(P))$.
  - Proof sketch added: quotient by the constant subspace, lift, identification via the globalSections_iff lemma.
- **Added section** "Mathlib-status flag: the H¹-vanishing input" — documents that both ingredients (LES + skyscraper vanishing) are already consumer obligations of RR.2, so RR.3 introduces no new Mathlib obligation.
- **Added section** "Out of scope" — explicitly lists what is deferred: general $\mathcal O_C(D)$, Serre duality, the general-$g$ formula, the `Proj.fromOfGlobalSections` morphism (RR.4), the general "$\deg > 2g-2 \Rightarrow H^1 = 0$" vanishing, projective-space-of-linear-system structure.

## Cross-references introduced

- `\uses{def:divisor_closed_point}` — verify `def:divisor_closed_point` exists in `RiemannRoch_WeilDivisor.tex` (confirmed; RR.1 L300+).
- `\uses{def:codim1_cycles}` — verify in `RiemannRoch_WeilDivisor.tex` (confirmed; RR.1 L219).
- `\uses{def:prime_divisor}` — verify in `RiemannRoch_WeilDivisor.tex` (confirmed; RR.1 L144).
- `\uses{def:order_at_point}` — verify in `RiemannRoch_WeilDivisor.tex` (confirmed; RR.1 L260).
- `\uses{def:principal_divisor}` — verify in `RiemannRoch_WeilDivisor.tex` (confirmed; RR.1 L423).
- `\uses{def:divisor_degree}` — verify in `RiemannRoch_WeilDivisor.tex` (confirmed; RR.1 L350).
- `\uses{def:genus}` — verify in `Genus.tex` (confirmed; Genus L16).
- `\uses{def:Scheme_HModule}` — verify in `Cohomology_StructureSheafModuleK.tex` (confirmed; that chapter L187).
- `\uses{def:eulerChar_curve}` — verify in `RiemannRoch_RRFormula.tex` (confirmed; RR.2 L90).
- `\uses{thm:euler_char_eq_deg_plus_one_minus_genus}` — verify in `RiemannRoch_RRFormula.tex` (confirmed; RR.2 L184).
- `\uses{def:Scheme_cechCochain_OC}` — referenced in the Mathlib-status flag section, verify in `Cohomology_StructureSheafModuleK.tex` (confirmed; that chapter L234).

All `\uses{...}` cross-references point at labels already on disk in sibling chapters.

## References consulted

- `references/summary.md` — index check; identified Hartshorne and stacks-coherent as the directive's named sources.
- `references/hartshorne-algebraic-geometry.md` — reference card; located doc-page → PDF-page offsets (+17 body) and confirmed IV.1 / II.6 / II.7 page ranges.
- `references/hartshorne-algebraic-geometry.pdf` PDF pp.~311--314 (doc IV.1, pp.~294--297) — rendered the four-page block containing Theorem IV.1.3 (Riemann--Roch), the inductive-step proof, Lemma IV.1.2 (vanishing of $\ell$ for negative degree), Example IV.1.3.5 (genus-0 ⇒ rational), and Exercise IV.1.1 (existence of a nonconstant rational function regular off a single point). Verbatim quotes for the theorem, the inductive-step SES, Proposition 7.7(b), and Exercise 1.1 were copied character-by-character from these rendered pages.
- `references/hartshorne-algebraic-geometry.pdf` PDF pp.~161, 167 (doc II.6, pp.~144, 150) — rendered to capture the verbatim definition of $\mathscr L(D)$ (the subsheaf-of-$\mathscr K$ construction) and Proposition 6.13(a) (that $\mathscr L(D)$ is an invertible sheaf).
- `references/hartshorne-algebraic-geometry.pdf` PDF p.~174 (doc II.7, p.~157) — rendered for the verbatim Proposition 7.7 statement and its proof of part (b) (the explicit identification of $H^0$ of $\mathscr L(D_0)$ with rational functions $f$ satisfying $(f) \geq -D_0$).
- `references/stacks-coherent.md` — reference card; checked for an H¹-vanishing tag for line bundles on curves with $\deg > 2g-2$. **Not in the local file** (the file only covers tag 02KH, flat base change). Did not need a new retriever dispatch because the chapter's H¹-vanishing route avoids the general bound and uses the structural LES at $D = 0$ instead.
- `blueprint/src/chapters/RiemannRoch_WeilDivisor.tex` — sibling chapter (RR.1); read to harvest standing-typeclass language, label set, and prior verbatim quotes that I can cross-reference.
- `blueprint/src/chapters/RiemannRoch_RRFormula.tex` — sibling chapter (RR.2); read to align with the project's prose conventions ($\chi$-identity, SES inductive-step argument, project notation $\mathcal O_C(D)$, "Lean signature scope" paragraph format) and to reuse the structural SES that is the basis of the H¹-vanishing argument.
- `blueprint/src/chapters/Genus.tex` — sibling chapter; confirmed `def:genus` label + the `g(C) = \dim_k H^1(C, \mathcal O_C)` formulation that the H¹-vanishing route relies on.

## Macros needed (if any)

None. The chapter uses only macros already in use in sibling chapters (`\Div`, `\div`, `\Cref`, `\ord`, etc.).

## Reference-retriever dispatches (if any)

None. The Hartshorne PDF was already in `references/`; rendering and quoting were done in-session via the Read tool's PDF support. The stacks-coherent card was consulted but did not need to be extended (the chapter's route deliberately avoids the general $\deg > 2g - 2$ vanishing).

## Notes for Plan Agent

- **The H¹-vanishing is NOT a gap.** The directive flagged this as a worry; I checked. The vanishing $H^1(C, \mathcal O_C(P)) = 0$ on a genus-0 curve is delivered by the LES from the SES $0 \to \mathcal O_C \to \mathcal O_C(P) \to k(P) \to 0$, which is the *same* SES that RR.2's inductive step already uses (with $D = 0$). The two cohomological inputs (LES of the project's $\Module\bar k$-sheaf-cohomology pipeline; vanishing of $H^i(C, k(P))$ for $i \geq 1$) are both already consumer obligations of RR.2's `thm:euler_char_eq_deg_plus_one_minus_genus`. RR.3 inherits them without introducing any new Mathlib gap. There is therefore no need to split this chapter or push the vanishing back into RR.2.
- **Naming choice — `lineBundleAtClosedPoint`, not `lineBundleOfDivisor`.** The directive's Lean signature names target only the closed-point specialisation. I followed that; the general $\mathcal O_C(D)$ construction is recorded under "Out of scope" with a note that it is queued for the post-RR-bridge follow-up. If the plan agent later decides RR.4 needs the general $\mathcal O_C(D)$ (e.g.\ to phrase a degree-$d$ embedding), this chapter will need a sequel; for the genus-0 critical path the point case suffices.
- **Filename mismatch with RR.2 prose.** RR.2 (currently on disk) refers to the sibling chapter as `RiemannRoch_OcOfD.tex`; the directive names the file `RiemannRoch_OCofP.tex` and I followed the directive. RR.2's prose ("sibling chapter `RiemannRoch_OcOfD.tex`, to be added") is therefore out-of-date by exactly one filename; the plan agent (or a subsequent writer round on RR.2) should refresh those four prose references in `RiemannRoch_RRFormula.tex` to point at `RiemannRoch_OCofP.tex`. I did not touch RR.2 since it is outside my write-domain.
- **`content.tex` not modified.** Per the directive's verification clause, `\input{RiemannRoch_OCofP}` is the plan agent's job. The chapter is on disk and ready to be `\input`-ed; it compiles independently against the macros already loaded by the project preamble.
- **Hartshorne IV.1.3.4 (the directive's primary citation pointer)**. The directive named "Hartshorne IV.1.3.4" as the source. Hartshorne's Example 1.3.4 in fact reads: "We say a divisor $D$ is *special* if $l(K - D) > 0$, and that $l(K - D)$ is its *index of speciality*. Otherwise $D$ is *nonspecial*. If $\deg D > 2g - 2$, then by (1.3.3), $\deg(K - D) < 0$, so $l(K - D) = 0$ (1.2). Thus $D$ is nonspecial." This is the source of the "$\deg L > 2g - 2 \Rightarrow l(K-L) = 0$" Serre-duality-flavoured statement — which the chapter avoids using. The actual chapter cites the *combined* chain from Theorem 1.3 (RR formula, p.~295), the inductive-step SES (p.~296), Lemma 1.2 (the $l$-vanishing, p.~295), Example 1.3.5 (the genus-0 application, p.~297), and Exercise 1.1 (the existence statement, p.~297). The verbatim quotes are taken from the actual locations rather than from a single "IV.1.3.4" label that does not back the statement the directive wanted.

## Strategy-modifying findings

None. The chapter as drafted respects the directive's strategy:
- direct cohomological vanishing route (no Serre duality);
- gates only on RR.2's `thm:euler_char_eq_deg_plus_one_minus_genus`;
- specialises to the closed-point case only.

No strategy-level surprises surfaced during drafting.
