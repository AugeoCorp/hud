import { render, screen } from "@testing-library/react";
import { describe, expect, it } from "vitest";

import { Layer } from "./Layer";

describe("<Layer />", () => {
	it("passes its depth to CSS", () => {
		render(<Layer depth={12}>Panel</Layer>);
		expect(screen.getByText("Panel").style.getPropertyValue("--depth")).toBe(
			"12",
		);
	});
});
