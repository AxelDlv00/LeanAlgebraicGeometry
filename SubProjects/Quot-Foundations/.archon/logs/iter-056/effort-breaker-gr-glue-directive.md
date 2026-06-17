## Target
`def:scheme_modules_glue` (`\lean{AlgebraicGeometry.Scheme.Modules.glue}`) in
blueprint/src/chapters/Picard_GrassmannianQuot.tex (block at ~L190–307).

## Granularity
One level — the construction's main mechanical steps, each its own sub-lemma/sub-def with statement +
informal proof + `\uses`. This is a multi-hundred-line from-scratch build with NO Mathlib turn-key; the
current block has only prose, no decomposed pieces. Decompose so the prover can formalize one piece per
iter.

## Proof structure (cut along these seams)
`glue` produces, from a `Scheme.GlueData` `D` with charts `Uᵢ`, overlaps `Vᵢⱼ`, per-chart sheaves
`𝓜ᵢ`, and transition isos `gᵢⱼ : fᵢⱼ* 𝓜ᵢ ≅ (tᵢⱼ∘fⱼᵢ)* 𝓜ⱼ` satisfying (C1)/(C2), a glued sheaf
`𝓜` on `X = D.glued` with restriction isos `ρᵢ : ιᵢ* 𝓜 ≅ 𝓜ᵢ`. Suggested sub-pieces:
1. The glued PRESHEAF of modules: `V ↦ { (sᵢ) ∈ ∏ᵢ Γ(𝓜ᵢ, fᵢ⁻¹ V) | overlap-compatible via gᵢⱼ }`,
   with restriction maps. (Section-gluing primitive: `existsUnique_gluing'`.)
2. The `𝓞_X`-module structure on the glued presheaf (pointwise from the chart module structures).
3. The SHEAF condition for the glued presheaf (locality + gluing from the chart sheaves' sheaf
   conditions over the Zariski cover `{ιᵢ}`).
4. The restriction isomorphisms `ρᵢ : ιᵢ* 𝓜 ≅ 𝓜ᵢ` and their compatibility with `gᵢⱼ` on overlaps —
   where (C2) (transported via `lem:modules_pullback_basechange_transport` /
   `def:modules_pullbackComp`) is consumed.
5. The characterisation up to unique iso (uniqueness of the glued sheaf given the restriction property).
6. Morphism descent: a family `φᵢ : 𝓜ᵢ → 𝓝ᵢ` commuting with transitions glues to a unique
   `φ : 𝓜 → 𝓝` with `ρᵢᴺ ∘ ιᵢ*φ = φᵢ ∘ ρᵢᴹ`.

Each sub-piece: give it a `\label`, a project-notation statement, a one-line-to-paragraph informal proof,
and an accurate `\uses{}`. Keep `def:scheme_modules_glue` as the assembling node `\uses`-ing the pieces.

## Existing infrastructure (already proven — reference, do not re-decompose)
`overRestrictPullbackIso` (chart-restriction bridge), `existsUnique_gluing'` (section gluing),
`pullbackBaseChangeTransport`/`glueData_bridge_{src,mid,tgt}` (C2 transport), the C1/C2 cocycle
hypotheses (already in the `glue` signature).

## Out of scope
Do NOT touch other chapters. Do NOT add `\leanok`. Do NOT decompose nodes already marked done
(`lem:gr_opensMap_final`, `lem:gr_pullbackFreeIso`, the functor blocks). Project-bespoke construction —
no external source citation required.
