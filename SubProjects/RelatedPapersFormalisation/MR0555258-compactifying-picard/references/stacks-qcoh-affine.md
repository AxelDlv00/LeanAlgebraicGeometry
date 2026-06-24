# Stacks Project — quasi-coherent sheaves on affine schemes

Provenance: fetched 2026-06-24 from the Stacks Project (https://stacks.math.columbia.edu),
via WebFetch of the tag pages below. These are the verbatim lemma statements backing the
project-local affine bridge anchor `External.affine_fp_tilde`. (Used because the standard
reference for the affine quasi-coherence equivalence — Hartshorne II.5.5 / EGA I 1.4 — is
not in `references/`; the Stacks Project is the freely-fetchable canonical source.)

## Lemma 26.7.4 — Tag 01IA  (https://stacks.math.columbia.edu/tag/01IA)
Section 26.7 "Quasi-coherent sheaves on affines".

> Let $(X, \mathcal{O}_X) = (\mathop{\mathrm{Spec}}(R), \mathcal{O}_{\mathop{\mathrm{Spec}}(R)})$
> be an affine scheme. Let $\mathcal{F}$ be a quasi-coherent $\mathcal{O}_X$-module. Then
> $\mathcal{F}$ is isomorphic to the sheaf associated to the $R$-module $\Gamma(X, \mathcal{F})$.

## Lemma 26.7.5 — Tag 01IB  (https://stacks.math.columbia.edu/tag/01IB)
Section 26.7 "Quasi-coherent sheaves on affines".

> Let $(X, \mathcal{O}_X) = (\mathop{\mathrm{Spec}}(R), \mathcal{O}_{\mathop{\mathrm{Spec}}(R)})$
> be an affine scheme. The functors $M \mapsto \widetilde{M}$ and
> $\mathcal{F} \mapsto \Gamma(X, \mathcal{F})$ define quasi-inverse equivalences of categories
> between the category of quasi-coherent $\mathcal{O}_X$-modules and the category of $R$-modules.

## Lemma 28.17.2 — Tag 01PC  (https://stacks.math.columbia.edu/tag/01PC)
Section 28.17 "Characterizing modules of finite type and finite presentation".

> The quasi-coherent sheaf of $\mathcal{O}_X$-modules $\widetilde M$ is an $\mathcal{O}_X$-module
> of finite presentation if and only if $M$ is an $R$-module of finite presentation.

## Lemma 28.17.1 — Tag 01PB  (https://stacks.math.columbia.edu/tag/01PB)
Section 28.17 (finite-type analogue, recorded for completeness).

> The quasi-coherent sheaf of $\mathcal{O}_X$-modules $\widetilde M$ is a finite type
> $\mathcal{O}_X$-module if and only if $M$ is a finite $R$-module.

## Consequence used by the project
A finitely-presented (hence quasi-coherent) $\mathcal{O}_{\Spec R}$-module $I$ is, by 01IA,
isomorphic to $\widetilde{M}$ with $M = \Gamma(\Spec R, I)$; by 01PC the module $M$ is then
of finite presentation over $R$ (since $\widetilde M \cong I$ is of finite presentation). This
is exactly the statement anchored as `External.affine_fp_tilde`.
