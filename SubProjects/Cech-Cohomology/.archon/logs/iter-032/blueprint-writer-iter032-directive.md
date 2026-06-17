# Blueprint-writer directive — iter-032

Edit ONLY `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex` (the consolidated chapter covering
all Cohomology/*.lean files). Three jobs. Citation discipline is mandatory: every new/edited block that
derives from a source needs `% SOURCE:` + `% SOURCE QUOTE:` (verbatim, original language) + a visible
`\textit{Source: …}` line. Read the actual local source files before quoting. Do NOT add `\leanok` (the
deterministic sync owns it).

Sources available locally:
- `references/stacks-schemes.tex` — Stacks "Schemes": Tag 01HV `lemma-spec-sheaves` (Γ(D(f),~M)=M_f),
  the `~M` construction (lines ~593–603), `lemma-widetilde-pullback`, Tag 01I8 `lemma-quasi-coherent-affine`.
- `references/stacks-coherent.tex` — Stacks "Cohomology of Schemes": Tag 02KG.
- `references/homological-acyclic-homology.tex` / `homological-acyclic-derived.tex` — homological algebra.

---

## JOB 1 (PRIMARY — must-fix this iter) — decompose `lem:qcoh_localized_sections` into P1a + P1b

The lemma `lem:qcoh_localized_sections` (≈ line 3868, pin `AlgebraicGeometry.qcoh_localized_sections`,
Tag 01HV `lemma-widetilde-pullback`) currently carries a `% NOTE (review iter-031)` flagging that its proof
silently elides two sub-gaps. A prover (iter-031) located these precisely; the progress-critic flagged the
route CHURNING and the required corrective is exactly this structural decomposition. Split the monolithic P1
into two `\uses`-linked sub-lemmas, each a self-contained block with statement + `\label{}` + `\lean{}` pin +
`\uses{}` + a textbook-level informal proof, then rewrite `lem:qcoh_localized_sections`'s proof to consume
them (its `\uses` becomes `{lem:exists_finite_basicOpen_subcover, lem:qcoh_localized_sections_restriction,
lem:isLocalizedModule_of_span_cover}` or whatever names you choose — keep them consistent).

### P1b — pure-algebra patching primitive (INDEPENDENT, dispatch-ready THIS iter)
New `\begin{lemma}` block. This is the genuinely reusable pure-commutative-algebra fact:
**`IsLocalizedModule` is local on a finite spanning cover.** The strategy-critic confirmed `IsLocalizedModule.mk`
and `IsLocalizedModule.ext` are present in `Mathlib.Algebra.Module.LocalizedModule` and that this is
independent of the cohomology machinery (no regress). The prover noted only `IsLocalizedModule.mk`/
`.of_linearEquiv` exist, so the primitive must be built from `.mk`'s three fields (`map_units`, `surj'`,
`exists_of_eq`) over a finite `s : Fin n → R` with `Ideal.span (Set.range s) = ⊤`, consuming per-`sⱼ`
localisation data.

**Critical (strategy-critic): pin the EXACT statement** — the one-line phrasing "IsLocalizedModule is local on
a span cover" admits several formalizations and the prover needs the precise one that feeds P1. State it as a
standalone algebra lemma roughly of the shape: given `R`, an `R`-module map `g : M →ₗ[R] N`, an element
`f : R`, a finite family `s : Fin n → R` with `span(range s) = ⊤`, and the hypothesis that for each `j` the
base-changed/away-localised map exhibits the appropriate localisation at `f` over the cover piece `D(sⱼ)`,
conclude `IsLocalizedModule (Submonoid.powers f) g`. Choose a `\lean{}` name such as
`AlgebraicGeometry.isLocalizedModule_of_span_cover` (or a more algebra-appropriate namespace if you prefer —
it is pure algebra). Make the hypotheses concrete enough that a prover can formalize the signature without
guessing. Mark it project-bespoke (no external source needed for the abstract algebra fact) OR cite the
glueing-of-fractions argument in `lemma-widetilde-pullback` / Stacks tilde construction if you quote one.
Give a complete informal proof verifying each `IsLocalizedModule.mk` field via the spanning cover (partition
of unity `1 = Σ rⱼ sⱼ^{Nⱼ}` style argument for surjectivity and for the equaliser/annihilator field).

### P1a — affine restriction infra (load-bearing geometry, blueprint only — NOT dispatched this iter)
New `\begin{lemma}` (or two) block(s) capturing: for `[IsQuasicoherent F]` on `Spec R` and `f : R`, the
restriction `F|_{D(f)}` is a `(Spec R_f).Modules` object admitting a `.Presentation`, obtained by refining the
arbitrary-open cover of `QuasicoherentData F` down to basic opens via `lem:exists_finite_basicOpen_subcover`
+ `Presentation.map` along the open immersion `D(fⱼ) ⟶ X(φ j)`, identifying `D(f) ≅ Spec R_f` at the
`(Spec R).Modules` level. `\lean{}` name e.g. `AlgebraicGeometry.qcoh_localized_sections_restriction` /
`AlgebraicGeometry.isQuasicoherent_restrict_basicOpen`. Cite Stacks `lemma-widetilde-pullback` / 01I8.
Flag with a `% NOTE:` that the SheafOfModules-restriction-to-basic-open ≅ Spec-of-localization machinery is
absent from Mathlib and is project-to-build (so the next planner knows P1a is the harder geometry lane). Give
the informal proof at the level the eventual prover needs.

Rewrite `lem:qcoh_localized_sections` proof to: choose the finite basic-open cover (P0), trivialise `F` on
each `D(fⱼ)` (P1a), get per-`fⱼ` localisation of sections from `lemma-widetilde-pullback`, then patch via P1b.
Update its `% NOTE` to reflect that the decomposition now exists (P1a + P1b are separate blocks).

---

## JOB 2 — write the informal proof for `lem:tilde_preserves_kernels` (∞-source, currently no proof)

`lem:tilde_preserves_kernels` (≈ line 3968, pin `AlgebraicGeometry.tilde_preserves_kernels`) is a leandag
∞-source: it has a statement but NO informal proof, so the graph assigns it infinite effort and no prover may
touch it. Write a complete textbook-level informal proof so it leaves the ∞-source list.

Statement (confirm against the existing block): the functor `~ : ModuleCat R ⥤ (Spec R).Modules`, `M ↦ ~M`,
preserves kernels (equivalently is left-exact / preserves finite limits). Informal proof: kernels in the
sheaf-of-modules category are computed stalkwise; the stalk of `~M` at a prime `p` is the localisation `M_p`;
localisation `R → R_p` is flat (exact), so it preserves the kernel of any `R`-linear map; therefore the stalk
of `~(\ker φ)` equals `\ker(~φ)` at every `p`, and a stalkwise isomorphism of sheaves is an isomorphism. Cite
the `~M` construction / stalk computation in Stacks Schemes Tag 01HV (`lemma-spec-sheaves`, the stalk
`(~M)_p = M_p` clause) — read `references/stacks-schemes.tex` and quote verbatim. Mark with a `% NOTE:` that
the corresponding Lean `PreservesFiniteLimits`/`PreservesKernels` instance for `~` is absent from Mathlib and
is project-to-build (Route-P P3 sub-gap).

---

## JOB 3 — clear coverage debt (9 CechBridge `…Fam` helpers, currently `unmatched`)

These 9 prover-created helpers (iter-031, `CechBridge.lean`, `section FamilyParameterizedBridge`) have no
blueprint entry — bundle each name into the `\lean{...}` list of the existing related block, exactly as the
non-`Fam` originals are listed (no new blocks needed; mirror the existing bundling pattern):
- Into `lem:cech_complex_hom_identification`'s `\lean{}` list: `AlgebraicGeometry.cechComplex_hom_identificationFam`,
  `AlgebraicGeometry.homCechCosimplicialFam`, `AlgebraicGeometry.homCechComplexFam`,
  `AlgebraicGeometry.homCechSectionIsoAppFam`, `AlgebraicGeometry.homCechSectionCosimplicialIsoFam`,
  and the private helpers `AlgebraicGeometry.homCechSectionIsoApp_hom_πFam`,
  `AlgebraicGeometry.homCechCosimplicial_δFam`.
- Into `lem:section_cech_complex_mapop_iso`'s `\lean{}` list: `AlgebraicGeometry.homCechComplexMapOpIsoFam`,
  `AlgebraicGeometry.homCechComplex_d_eqFam`.
(The two NAMED targets `sectionCechComplexMapOpIsoFam` + `injective_cech_acyclicFam` are already pinned —
verify they are present and do not duplicate.) Put each helper on the most appropriate existing block by what
it actually supports; the above is the recommended assignment from the prover's handoff. Adjust `\uses{}` on
those blocks only if a genuinely new dependency edge is introduced (these are mechanical mirrors, so usually
no `\uses` change is needed).

---

## Out of scope
- Do NOT touch `def:affine_cover_system` (already correctly references the family form for the
  injective_acyclic field) or any AffineSerreVanishing cover-system block — they are HARD-GATE-cleared.
- Do NOT add `\leanok` anywhere.
- Do NOT edit any other chapter file.

## Report
List every block added/edited with its label, `\lean{}` pin, and `\uses{}`. Flag any P1a/P1b statement choice
that you were uncertain about so the planner can validate the signature before dispatch.
