# Reference Retriever Directive — iter-150

## Slug

stacks-and-classical-ag-iter150

## Topic

The project needs authoritative literature for the chart-algebra piece (ii) closure on `AlgebraicJacobian/Cotangent/ChartAlgebra.lean` + `ChartAlgebraS3.lean`. Specifically, the four (S3.*) sub-claims in the path-(b) decomposition of `constants_integral_over_base_field`:

1. **(S3.sep.1)** `Smooth ⇒ IsGeometricallyReduced` on Γ — Stacks Project Tag 04QM (smooth implies geometrically reduced for morphisms of schemes), Tag 0334 (definition of geometrically reduced).
2. **(S3.sep.2)** `IsGeometricallyReduced + FiniteDimensional ⇒ IsSeparable` for field extensions — Stacks Project Tag 0BJF (and surrounding Tag 030V, 030W, 030X on separable / geometrically reduced field extensions).
3. **(S3.pi.1)** Flat base change of Γ for proper schemes: the canonical map `Γ(X, O_X) ⊗_k K → Γ(X_K, O_{X_K})` is an isomorphism when X/k is proper and K/k is a field extension. Stacks Project Tag 02KH (cohomology and flat base change, specialised to H^0). Companion content: Tag 0BUG (base change for proper morphisms).
4. **(S3.pi.2)** `IsPurelyInseparable` from a unique-minimal-prime-of-base-change hypothesis — Stacks Project Tag 05DH (purely inseparable extensions), Tag 030V (purely inseparable closures).

Additionally for the KDM (Kähler differential module) bridge:

5. **(BR.2)–(BR.5)** standard-smooth ⇒ free Ω; coefficient derivations; `Differential.ContainConstants`. References: Stacks Project Tag 07F4 (universal derivations on standard-smooth algebras), Tag 07F1 (the cotangent module for standard smooth).

And for the broader project context (per user-hint: Hartshorne / Eisenbud / FGA / Matsumura):

6. **Hartshorne, "Algebraic Geometry"** — Chapter II §8 (Differentials, including II.8.6A, II.8.7), Chapter III §1 (Derived Functors), Chapter III §5 (cohomology of projective space), Chapter IV §1 (Riemann–Roch on curves; smooth curves over k = k̄).
7. **Eisenbud, "Commutative Algebra with a View Toward Algebraic Geometry"** — §17 (Differentials, especially 17.7 the Jacobian criterion), §16 (modules of differentials).
8. **Matsumura, "Commutative Ring Theory"** — §26 (Derivations), §28 (Separable extensions).
9. **FGA — Bourbaki Seminar 232** (Grothendieck, "Technique de descente. II. Le théorème d'existence en géométrie algébrique", Sém. Bourbaki 232, 1961/62; predecessor of FGA Explained Ch. 5 by Nitsure on Picard schemes). Also Bourbaki Seminar 221 (Grothendieck, "Technique de descente. I"). These are Route A (FGA Picard) references; needed for STRATEGY.md grounding even though Route A is off-critical-path.

## What the dispatcher will use this for

The user-hint flagged that the iter-149 plan-agent fabricated `references/literature-crosscheck-iter149.md` (no API key, silent fallback to internal knowledge). The file has been deleted. This dispatch replaces it with **authentic, verifiable** literature summaries that future planner + writer rounds can cite. Specifically:

- The blueprint chapter `RigidityKbar.tex` § "Chart-algebra piece (ii) first-class decomposition" already names Stacks Tags inline; the planner needs the underlying tag content distilled so that subsequent writer rounds can backfill literature excerpts as `% NOTE:` comments preceding each declaration (user-hint #3 — reference integration).
- Future writer rounds revising `Differentials.tex`, `RigidityKbar.tex`, `Jacobian.tex` will need to ground new prose in Hartshorne / Eisenbud / Matsumura citations rather than hallucinate.

## Seeds

- Stacks Project: https://stacks.math.columbia.edu/tag/04QM, /0334, /0BJF, /030V, /02KH, /0BUG, /05DH, /07F4, /07F1.
- Hartshorne, "Algebraic Geometry" (Springer GTM 52, 1977). ISBN 978-0-387-90244-9.
- Eisenbud, "Commutative Algebra with a View Toward Algebraic Geometry" (Springer GTM 150, 1995). ISBN 978-0-387-94269-8.
- Matsumura, "Commutative Ring Theory" (CUP, 1989). ISBN 978-0-521-36764-6.
- FGA: Grothendieck, "Technique de descente. I + II", Séminaire Bourbaki Exp. 190 (1959/60), Exp. 195 (1959/60), Exp. 212 (1960/61), Exp. 221 (1960/61), Exp. 232 (1961/62). Available via numdam.org. Or use the modern reference "FGA Explained" (eds. Fantechi/Göttsche/Illusie/Kleiman/Nitsure/Vistoli, AMS 2005) Chapter 5 (Picard schemes) by Nitsure.
- Search queries: "Stacks Project flat base change proper cohomology"; "Stacks Project standard smooth Kähler differential"; "Hartshorne III.12 base change"; "FGA Explained Nitsure Picard scheme".

## Out of scope

- DO NOT fabricate. If a tag is paywalled or doesn't say what the seed claims, report "not found" and explain.
- DO NOT pull in arXiv survey papers unless they are the canonical reference for one of the listed topics.
- DO NOT touch any file outside `references/`.

## Depth expected

**medium** for Stacks Project tags (one paragraph per tag distilling the statement + the proof outline + the prerequisite tags it references) and the classical textbooks (one section's worth, focused on the specific theorems named above). **shallow** for FGA / FGA Explained (just the chapter title + scope, since Route A is off-critical-path this iter).

## Slugs to produce (one file per source)

- `references/stacks-04QM.md` — Tag 04QM smooth implies geometrically reduced.
- `references/stacks-0334.md` — Tag 0334 geometrically reduced (definition + characterizations).
- `references/stacks-0BJF.md` — Tag 0BJF geometrically reduced + finite ⇒ separable (this may live in a slightly different tag; report what you find).
- `references/stacks-02KH.md` — Tag 02KH flat base change for cohomology (H^0 row).
- `references/stacks-0BUG.md` — Tag 0BUG proper base change.
- `references/stacks-05DH.md` — Tag 05DH purely inseparable extensions.
- `references/stacks-07F4.md` — Tag 07F4 standard smooth derivations.
- `references/hartshorne-ag.md` — Hartshorne Chapter II §8 + Chapter III §1, §5, §12.
- `references/eisenbud-ca.md` — Eisenbud §16, §17.
- `references/matsumura-crt.md` — Matsumura §26, §28.
- `references/fga-picard.md` — FGA / FGA Explained Ch. 5 (Nitsure), shallow.

After writing each, append a one-line bullet to `references/summary.md`.

Write your task report to `.archon/task_results/reference-retriever-stacks-and-classical-ag-iter150.md`.

Return COMPLETE / NOT_FOUND / PARTIAL per the standard format. Do NOT silently downgrade quality — if Hartshorne isn't available online (which it likely isn't, as a print book), say so honestly and skip it; the planner can re-source those from a different angle. Stacks Project tags are open access and should all resolve.
