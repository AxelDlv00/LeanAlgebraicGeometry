# blueprint-writer directive — clear coverage debt for 5 new iter-045 helper decls

## Chapter to edit

`blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex` (ONLY this chapter).

## Goal

Five Lean declarations landed iter-045 in `AlgebraicJacobian/Cohomology/QcohTildeSections.lean` with
NO blueprint block (DAG `unmatched` debt — they are invisible isolated nodes). Author one thin block
for each, each with `\label{}`, `\lean{...}`, accurate `\uses{...}`, and at least a one-line informal
proof. These are all **general-open-`V` companions** (or private wrappers) of existing `V=⊤` blocks
already in this chapter — anchor each new block immediately after its `V=⊤` sibling and write it as
"the general-`V` companion of [sibling]".

## The five declarations (with their existing siblings, deps, and proof one-liners)

1. **`AlgebraicGeometry.modulesRestrictBasicOpen_smul_eq'`** (non-private)
   - Sibling: `lem:modulesRestrictBasicOpen_smul_eq` (the `V=⊤` version).
   - Statement: the general-open-`V` form — the module action on the affine tile
     `modulesRestrictBasicOpen g F` over an arbitrary open `V` transports rfl-style to `F.val`'s
     structure-sheaf action over the image open `ι ''ᵁ V`.
   - Proof: `rfl` (defeq of the restrict-functor action at any `V`).
   - `\uses{}`: same as the sibling (the tile-action definitional setup).

2. **`AlgebraicGeometry.tile_section_ring_identity'`** (non-private)
   - Sibling: `lem:tile_section_ring_identity` (the `V=⊤` version).
   - Statement: the general-open-`V` structure-sheaf ring identity (the morphism-level identity that
     `tile_scalar_compat'` discharges elementwise), at an arbitrary basic open `V` rather than `⊤`.
   - Proof: derive from the `V=⊤` case by post-composing with the restriction `ι ''ᵁ V ≤ ι ''ᵁ ⊤`,
     pushing the restriction through the two open-immersion section isos via the
     `appIso_inv_naturality` wrappers (see #4/#5 below); the `res(⊤≤⊤)=id` leg dies by `Subsingleton`
     of thin-category opens morphisms.
   - `\uses{lem:tile_section_ring_identity, ...}` plus the two private-wrapper labels you create in #4/#5.
   - **Bundle the two private wrappers `AlgebraicGeometry.appIso_inv_res` and
     `AlgebraicGeometry.appIso_inv_res_assoc` into THIS block's `\lean{...}` list** (private decls are
     NOT exempt from `unmatched`; they have no separate block). So this block's `\lean{}` names all
     three: `tile_section_ring_identity'`, `appIso_inv_res`, `appIso_inv_res_assoc`.

3. **`AlgebraicGeometry.tile_scalar_compat'`** (non-private)
   - Sibling: `lem:tile_scalar_compat` (the `V=⊤` version).
   - Statement: the general-open-`V` scalar-tower compatibility `R → R_g` — at an arbitrary open `V`,
     `r • x` (the `R`-action) equals `(algebraMap R R_g r) • x` (the `R_g`-action of the tile). The
     instance at `V = D(f̄)` is the keystone sub-need feeding `tile_section_localization`.
   - Proof: verbatim structure of the `V=⊤` proof but at arbitrary `V`: rewrite both actions through
     the smul bridges, then discharge the residual via `tile_section_ring_identity'` applied elementwise.
   - `\uses{lem:modulesSpecToSheaf_smul_eq, lem:modulesRestrictBasicOpen_smul_eq', lem:tile_section_ring_identity'}`.

(#4 and #5 — `appIso_inv_res` / `appIso_inv_res_assoc` — do NOT get their own blocks; they are bundled
into #2's `\lean{}` as instructed. They are private section-restriction forms of
`Scheme.Hom.appIso_inv_naturality`, restated with explicit `homOfLE`/image opens to be `rw`-matchable.)

## Out of scope

- Do NOT touch `lem:tile_section_localization` or its Step-4 sketch — a separate writer pass handles that
  after a mathlib-analogist consult returns. Do NOT touch any `\leanok` marker (the deterministic
  sync phase owns it). Do NOT add `\mathlibok` (these are project-bespoke companions, not Mathlib anchors).
- These five companions are routine general-`V` liftings of already-blueprinted `V=⊤` results; the
  source citation is the same Stacks 01HV(4) anchor the siblings carry — reuse it, do not invent a new
  source. If a sibling block lacks a usable citation you may consult `references/` but new retrieval is
  not expected.
