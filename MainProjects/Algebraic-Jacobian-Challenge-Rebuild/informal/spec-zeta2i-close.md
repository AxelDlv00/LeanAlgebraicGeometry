# Brick spec — ζ2·i close: finish `Over.exists_coherentCechWitness`

*Written 2026-07-13 (Fable). Consumer: one Opus implementation agent.*

## Mission

Close the single `sorry` at `AlgebraicJacobian/Picard/CoherentWitnessExists.lean:521`
(the final goal of `Over.exists_coherentCechWitness`), bring both `CoherentWitness*.lean`
files under the 500-line cap, wire them into the aggregator, and verify kernel-green +
axiom-clean. Do NOT touch `Challenge.lean`. Do NOT weaken the theorem statement or the
`CoherentCechWitness` fields.

## READ FIRST (in order)

1. `AlgebraicJacobian/Picard/CoherentWitness.lean` — whole file (the structure
   `CoherentCechWitness` at :255, `amitsurCover` at :234, the local-notation prelude).
2. `AlgebraicJacobian/Picard/CoherentWitnessExists.lean` — whole file. The module
   docstring (lines 8–40) states the full argument; the proof implements Steps A–G.
3. `AlgebraicJacobian/Picard/AmitsurCochain.lean` — the ζ2·P toolkit you'll cite
   (`Scheme.exists_global_unit_of_compatible`, `Scheme.global_unit_ext`,
   `Scheme.Hom.unitsAppLE_top`, `Over.unitsSndTopEquiv`, `Over.appTop_units_injective`,
   the `tensorFace₁₂/₁₃/₂₃` cofaces).
4. `informal/c1-etale-separatedness-assembly.md` §ζ2 — the design (context only).

## State at the `sorry` (line 521)

Goal: `Nonempty (CoherentCechWitness k A B 𝒩 γ)`. In scope (all established above):

- `𝒲 : (Sq).PointedCover`, `hW₁ : ∀ x, 𝒲.opens x ≤ (q₁) ⁻¹ᵁ 𝒩.opens ((q₁).base x)`-shaped
  refinement witnesses (`𝒲 ≤ 𝒩.pullback q₁` pointwise), `hW₂` likewise for `q₂`
  (obtained at :179; check exact shapes with `lean_goal`).
- `θ₀ : ∀ x : Sq, Γ(Sq, 𝒲.opens x)ˣ` with `hdown` (:185) — EXACTLY the `witness` field
  shape of the structure, with `cover := 𝒲`.
- `ω` (:253, `set` with `hω`) — the Amitsur defect of `θ₀` on `amitsurCover 𝒲`;
  `hle₂₃/hle₁₂/hle₁₃` are the refinement inequalities used in its formula, and they are
  DEFEQ to the inequalities in the structure's `coherent` field
  (`inf_le_left.trans inf_le_left`, `inf_le_left.trans inf_le_right`, `inf_le_right`).
- `ωbar : Γ(Scb, ⊤)ˣ` with `hωbar : ∀ z, (Scb).unitsRestrict le_top ωbar = ω z`-shaped
  gluing (from `exists_global_unit_of_compatible`; check the exact restriction shape).
- `χ : Γ(Sq, ⊤)ˣ` (:373) with `hχ` and
  `hglob : ωbar = Units.map (f₂₃).appTop.hom.toMonoidHom χ * Units.map (f₁₂).appTop.hom.toMonoidHom χ / Units.map (f₁₃).appTop.hom.toMonoidHom χ` (:378).

## The assembly (mathematics, from the module docstring)

Take `θ := fun x ↦ θ₀ x / (Sq).unitsRestrict (le_top) χ` on the same cover `𝒲`:

- `cover := 𝒲`, `le_pullbackInl := hW₁`, `le_pullbackInr := hW₂` (adjust to the exact
  refinement encoding).
- `witness`: expand the division (`map_div` — `unitsRestrict` along a fixed inequality is
  a group homomorphism). The two χ-terms on the overlap agree: restricting χ from ⊤ to
  `𝒲.opens x` and then to the overlap equals restricting from ⊤ directly (composition of
  restrictions — find the `unitsRestrict_unitsRestrict`/naturality lemma with
  `lean_local_search unitsRestrict`), same from the y side. So the relation reduces to
  `hdown` after cancelling the common χ factor (CommGroup rearrangement:
  `a/c * g = h * (b/c) ↔ a * g = h * b` — `div_mul_eq`, `mul_div_assoc` etc., or reuse
  the private helpers already in the file).
- `coherent`: for `z : Scb`, each coface term
  `(fᵢⱼ).unitsAppLE … (θ (…z))` splits (`map_div`) into the θ₀-term and the χ-term. Each
  χ-term is a pullback of a GLOBAL unit: bridge with `Scheme.Hom.unitsAppLE_top` /
  `Scheme.Hom.unitsAppLE_map` / `units_map_appTop_comp` (all used in the `factor` calc at
  :398–417 — imitate it) to rewrite it as
  `(Scb).unitsRestrict le_top (Units.map (fᵢⱼ).appTop.hom.toMonoidHom χ)`. The goal
  becomes `ω z / restrict(∂_Am χ) = 1`-shaped, i.e. exactly
  `hωbar z` composed with `congrArg (unitsRestrict …) hglob` plus the `map_mul/map_div`
  distribution. The private `telescope_mul_div`/`div_mul_div_eq_of_mul_div` helpers may
  close the final CommGroup step.

Use `lean_goal` at 521 first; build the term with `refine ⟨⟨𝒲, ?_, ?_, ?_, ?_, ?_⟩⟩` (or
`exact ⟨{ cover := 𝒲, … }⟩`) and work the fields one at a time (`lean_multi_attempt` for
candidate rewrites; NEVER a bare `simp` over the giant context — target rewrites only).

## 500-line cap (mandatory, after the proof is green)

`CoherentWitnessExists.lean` is 523 lines and will grow. Required end state: every file
≤ 500 lines. Preferred factoring (best structure, do this unless it genuinely fights you):

1. Move the correction step into `CoherentWitness.lean` as a REUSABLE public lemma —
   suggested shape: from (`𝒲`, refinements, `θ₀`, the `hdown`-shaped witness relation, a
   global `χ`, and the hypothesis `∀ z, ω_{θ₀} z = (Scb).unitsRestrict … (∂_Am χ …)`),
   conclude `Nonempty (CoherentCechWitness k A B 𝒩 γ)`. Name it per mathlib conventions
   (e.g. `CoherentCechWitness.nonempty_of_defect_eq_coboundary`); full docstring; this is
   exactly "dividing a witness by a global unit kills a glued Amitsur defect".
   `CoherentWitness.lean` has ~200 lines of headroom.
2. In `CoherentWitnessExists.lean`, derive the hypothesis from `hωbar` + `hglob` (a few
   lines) and apply the lemma.
3. Move the five `private` CommGroup/units helpers (:60–:103) to wherever they're used
   after the split; pure-CommGroup ones that survive should become clean public lemmas
   ONLY if no mathlib equivalent exists (search first: `lean_loogle`, `lean_leansearch`).
4. If after 1–3 either file exceeds 500 lines, deduplicate the three near-identical
   `hR₂₃/hR₁₂/hR₁₃` blocks via a local `have` taking the face data as arguments.

Fallback ladder: if the factoring fights dependent-type friction for >45 min, first land
the in-place green proof (sorry closed, file temporarily over-cap), then do the split as
a pure motion refactor with the kernel re-check after each move. Never leave the tree
red; never leave the final state over-cap.

## Wiring + verification (FOREGROUND, non-negotiable)

1. Add imports to `AlgebraicJacobian.lean`: `AlgebraicJacobian.Picard.CoherentWitness`
   and `.CoherentWitnessExists` (+ any new file), keeping the existing ordering
   convention of the Picard block. If the file changed under you, re-read and re-apply
   ONLY your lines.
2. `lake build` from the project root — run it in the FOREGROUND and block until it
   finishes; paste the tail in your report. (A cold-cache rebuild may already be running
   when you start — coordinate: wait for it rather than racing it.)
3. `lean_verify` on `AlgebraicGeometry.Over.exists_coherentCechWitness` (and on the new
   correction lemma): axioms must be exactly `[propext, Classical.choice, Quot.sound]`.
4. `grep -n -w sorry` on every touched file (expect zero matches; grep exits 1 then —
   don't `&&`-chain it).

## Report format (final message)

Files touched (with line counts) · declarations added/moved (name + one-line statement)
· build tail verbatim · `lean_verify` output verbatim · deviations from this spec and why
· anything discovered that the ζ2·ii spec-writer must know.
